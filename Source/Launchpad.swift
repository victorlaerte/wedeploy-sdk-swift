import Foundation

public class Launchpad {

	public typealias FailureCallback = NSError -> ()
	public typealias SuccessArrayCallback = [[String: AnyObject]] -> ()
	public typealias SuccessDictionaryCallback = [String: AnyObject] -> ()
	public typealias SuccessStatusCodeCallback = Int -> ()

	let server: String

	public enum Verb: String {
		case DELETE = "DELETE", GET = "GET", PATCH = "PATCH", POST = "POST",
		PUT = "PUT"
	}

	init(server: String) {
		self.server = server
	}

	public func add(
		path: String, document: AnyObject, success: SuccessDictionaryCallback,
		failure: FailureCallback? = nil) {

		request(
			path, success: success, failure: failure, method: .POST,
			body: document)
	}

	public func get(
		path: String, id: String, success: SuccessDictionaryCallback,
		failure: FailureCallback? = nil) {

		request("\(path)/\(id)", success: success, failure: failure)
	}

	public func get(
		path: String, query: Query?, success: SuccessArrayCallback,
		failure: FailureCallback? = nil) {

		request(
			path, success: success, failure: failure,
			query: query?.queryItems())
	}

	public func list(
		path: String, success: SuccessArrayCallback,
		failure: FailureCallback? = nil) {

		request(path, success: success, failure: failure)
	}

	public func remove(
		path: String, id: String, success: SuccessStatusCodeCallback,
		failure: FailureCallback? = nil) {

		request(
			"\(path)/\(id)", success: success, failure: failure,
			method: .DELETE)
	}

	public func update(
		path: String, id: String, document: AnyObject,
		success: SuccessDictionaryCallback, failure: FailureCallback? = nil) {

		request(
			"\(path)/\(id)", success: success, failure: failure, method: .PUT,
			body: document)
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

	func request<T>(
		path: String, success: (T -> ())?, failure: FailureCallback?,
		method: Verb = .GET, query: [NSURLQueryItem]? = nil,
		body: AnyObject? = nil) {

		let success = dispatchMainThread(success)
		let failure = dispatchMainThread(failure)

		let URL = NSURLComponents(string: server + path)!
		URL.queryItems = query

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
			request.HTTPBody = NSJSONSerialization.dataWithJSONObject(
				body, options: NSJSONWritingOptions.allZeros, error: error)
		}
	}

}