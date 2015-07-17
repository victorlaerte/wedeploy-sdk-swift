import Foundation

public protocol Transport {

	func send<T>(
		method: Launchpad.Verb, url: String, path: String,
		params: [NSURLQueryItem]?, headers: [String: String]?, body: AnyObject?,
		success: (T -> ())?, failure: (NSError -> ())?)

}

public class NSURLSessionTransport: Transport {

	public func send<T>(
		_ method: Launchpad.Verb = .GET, url: String, path: String,
		params: [NSURLQueryItem]? = nil, headers: [String: String]? = nil,
		body: AnyObject? = nil, success: (T -> ())?,
		failure: (NSError -> ())?) {

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

		if let h = headers {
			for (name, value) in h {
				request.addValue(value, forHTTPHeaderField: name)
			}
		}

		if let e = error {
			failure(e)
			return
		}

		let session = NSURLSession.sharedSession()

		session.dataTaskWithRequest(
			request,
			completionHandler: { (data, response, error) in
				if let e = error {
					failure(e)
					return
				}

				let httpResponse = response as! NSHTTPURLResponse
				let status = httpResponse.statusCode

				if ((data.length == 0) || (status == 204)) {
					success(status as! T)
					return
				}

				var parseError: NSError?

				let result = NSJSONSerialization.JSONObjectWithData(
						data, options: NSJSONReadingOptions.AllowFragments,
						error: &parseError)
					as! T

				if let e = parseError {
					failure(e)
					return
				}

				success(result)
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
			request.HTTPBody = string.dataUsingEncoding(
				NSUTF8StringEncoding, allowLossyConversion: false)
		}
		else {
			request.setValue(
				"application/json", forHTTPHeaderField: "Content-Type")

			request.HTTPBody = NSJSONSerialization.dataWithJSONObject(
				body, options: NSJSONWritingOptions.allZeros, error: error)
		}
	}

}