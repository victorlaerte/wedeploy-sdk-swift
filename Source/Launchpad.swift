import Foundation

public class Launchpad {

	let server: String

	init(server: String) {
		self.server = server
	}

	public func add(
			path: String, document: AnyObject,
			success: ([String: AnyObject] -> ()))
		-> Self {

		return self.request(
			path, success: success, method: "POST", body: document)
	}

	public func get(
			path: String, id: String, success: ([String: AnyObject] -> ()))
		-> Self {

		return self.request("\(path)/\(id)", success: success)
	}

	public func list(path: String, success: ([[String: AnyObject]] -> ()))
		-> Self {

		return self.request(path, success: success)
	}

	public func remove(path: String, id: String, success: (Int -> ()))
		-> Self {

		return self.request("\(path)/\(id)", success: success, method: "DELETE")
	}

	func request<T>(
			path: String, success: (T -> ()), method: String = "GET",
			body: AnyObject? = nil)
		-> Self {

		let URL = NSURL(string: self.server + path)!
		let request = NSMutableURLRequest(URL: URL)
		request.HTTPMethod = method

		if let obj: AnyObject = body {
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