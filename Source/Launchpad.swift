import Foundation

public class Launchpad {

	public enum Verb: String {
		case DELETE = "DELETE", GET = "GET", PATCH = "PATCH", POST = "POST",
		PUT = "PUT"
	}

	let server: String

	init(server: String) {
		self.server = server
	}

	public func add(
			path: String, document: AnyObject,
			success: ([String: AnyObject] -> ()))
		-> Self {

		return request(
			path, success: success, method: Verb.POST, body: document)
	}

	public func get(
			path: String, id: String, success: ([String: AnyObject] -> ()))
		-> Self {

		return request("\(path)/\(id)", success: success)
	}

	public func list(path: String, success: ([[String: AnyObject]] -> ()))
		-> Self {

		return request(path, success: success)
	}

	public func remove(path: String, id: String, success: (Int -> ()))
		-> Self {

		return request("\(path)/\(id)", success: success, method: Verb.DELETE)
	}

	public func update(
			path: String, id: String, document: AnyObject,
			success: ([String: AnyObject] -> ()))
		-> Self {

		return request(
			"\(path)/\(id)", success: success, method: Verb.PUT, body: document)
	}

	func request<T>(
			path: String, success: (T -> ()), method: Verb = Verb.GET,
			body: AnyObject? = nil)
		-> Self {

		let URL = NSURL(string: server + path)!
		let request = NSMutableURLRequest(URL: URL)
		request.HTTPMethod = method.rawValue

		if let string = body as? String {
			request.HTTPBody = string.dataUsingEncoding(
				NSUTF8StringEncoding, allowLossyConversion: false)
		}
		else if let obj: AnyObject = body {
			request.HTTPBody = NSJSONSerialization.dataWithJSONObject(
				obj, options: NSJSONWritingOptions.allZeros, error: nil)
		}

		let session = NSURLSession.sharedSession()

		session.dataTaskWithRequest(
			request,
			completionHandler: { (data, response, error) in
				let httpResponse = response as NSHTTPURLResponse
				let status = httpResponse.statusCode

				if ((data.length == 0) || (status == 204)) {
					success(status as T)
					return
				}

				let result = NSJSONSerialization.JSONObjectWithData(
						data, options: NSJSONReadingOptions.AllowFragments,
						error: nil)
					as T

				success(result)
			}
		).resume()

		return self
	}

}