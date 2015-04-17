import Foundation

public class Launchpad {

	public typealias Failure = NSError -> ()

	let server: String

	public enum Verb: String {
		case DELETE = "DELETE", GET = "GET", PATCH = "PATCH", POST = "POST",
		PUT = "PUT"
	}

	init(server: String) {
		self.server = server
	}

	public func add(
			path: String, document: AnyObject,
			success: ([String: AnyObject] -> ())? = nil,
			failure: Failure? = nil)
		-> Self {

		return request(
			path, success: success, failure: failure, method: Verb.POST,
			body: document)
	}

	public func get(
			path: String, id: String,
			success: ([String: AnyObject] -> ())? = nil,
			failure: Failure? = nil)
		-> Self {

		return request("\(path)/\(id)", success: success, failure: failure)
	}

	public func list(
			path: String, success: ([[String: AnyObject]] -> ())? = nil,
			failure: Failure? = nil)
		-> Self {

		return request(path, success: success, failure: failure)
	}

	public func remove(
			path: String, id: String, success: (Int -> ())? = nil,
			failure: Failure? = nil)
		-> Self {

		return request(
			"\(path)/\(id)", success: success, failure: failure,
			method: Verb.DELETE)
	}

	public func update(
			path: String, id: String, document: AnyObject,
			success: ([String: AnyObject] -> ())? = nil,
			failure: Failure? = nil)
		-> Self {

		return request(
			"\(path)/\(id)", success: success, failure: failure,
			method: Verb.PUT, body: document)
	}

	func request<T>(
			path: String, success: (T -> ())?, failure: (NSError -> ())?,
			method: Verb = Verb.GET, body: AnyObject? = nil)
		-> Self {

		let URL = NSURL(string: server + path)!
		let request = NSMutableURLRequest(URL: URL)
		request.HTTPMethod = method.rawValue

		if (body != nil) {
			setRequestBody(request, body: body!)
		}

		let session = NSURLSession.sharedSession()

		session.dataTaskWithRequest(
			request,
			completionHandler: { (data, response, error) in
				let httpResponse = response as NSHTTPURLResponse
				let status = httpResponse.statusCode

				if ((data.length == 0) || (status == 204)) {
					success?(status as T)
					return
				}

				let result = NSJSONSerialization.JSONObjectWithData(
						data, options: NSJSONReadingOptions.AllowFragments,
						error: nil)
					as T

				success?(result)
			}
		).resume()

		return self
	}

	func setRequestBody(request: NSMutableURLRequest, body: AnyObject) {
		if let stream = body as? NSInputStream {
			request.HTTPBodyStream = stream
		}
		else if let string = body as? String {
			request.HTTPBody = string.dataUsingEncoding(
				NSUTF8StringEncoding, allowLossyConversion: false)
		}
		else {
			request.HTTPBody = NSJSONSerialization.dataWithJSONObject(
				body, options: NSJSONWritingOptions.allZeros, error: nil)
		}
	}

}