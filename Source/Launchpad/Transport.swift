import Foundation

public protocol Transport {

	func send(
		method: Launchpad.Verb, url: String, path: String,
		params: [NSURLQueryItem]?, headers: [String: String]?, body: AnyObject?,
		success: (Response -> ())?, failure: (NSError -> ())?)

}

public class NSURLSessionTransport : Transport {

	public func send(
		_ method: Launchpad.Verb = .GET, url: String, path: String,
		params: [NSURLQueryItem]?, headers: [String: String]?, body: AnyObject?,
		success: (Response -> ())?, failure: (NSError -> ())?) {

		let success = dispatchMainThread(success)
		let failure = dispatchMainThread(failure)

		let URL = NSURLComponents(string: url + path)!
		URL.queryItems = params

		let request = NSMutableURLRequest(URL: URL.URL!)
		request.HTTPMethod = method.rawValue

		var error: NSError?

		if (body != nil) {
			setRequestBody(request, body: body!, error: &error)
		}

		if let e = error {
			failure(e)
			return
		}

		if let h = headers {
			for (name, value) in h {
				request.addValue(value, forHTTPHeaderField: name)
			}
		}

		let session = NSURLSession.sharedSession()

		session.dataTaskWithRequest(
			request,
			completionHandler: { (data, r, error) in
				if let e = error {
					failure(e)
					return
				}

				let httpURLResponse = r as! NSHTTPURLResponse
				let headerFields = httpURLResponse.allHeaderFields
				var headers = [String: String]()

				for (key, value) in headerFields {
					headers[key.description] = value as? String
				}

				let response = Response(
					statusCode: httpURLResponse.statusCode, headers: headers,
					body: data)

				success(response)
			}
		).resume()

		return
	}

	func dispatchMainThread<T>(block: (T -> ())?) -> (Any? -> ()) {
		return { value in
			if let b = block {
				dispatch_async(dispatch_get_main_queue(), {
					b(value as! T)
				})
			}
		}
	}

	func setRequestBody(
		request: NSMutableURLRequest, body: AnyObject, error: NSErrorPointer) {

		if let stream = body as? NSInputStream {
			request.HTTPBodyStream = stream
		}
		else if let string = body as? String {
			request.HTTPBody = string.dataUsingEncoding(NSUTF8StringEncoding)
		}
		else {
			request.setValue(
				"application/json", forHTTPHeaderField: "Content-Type")

			request.HTTPBody = NSJSONSerialization.dataWithJSONObject(
				body, options: NSJSONWritingOptions.allZeros, error: error)
		}
	}

}