import Foundation

public class Launchpad {

	let server: String

	init(server: String) {
		self.server = server
	}

	public func delete(path: String, success: (Int -> ()))
		-> Self {

		return self.request(path, success: success, method: "DELETE")
	}

	public func get(path: String, success: ([String: AnyObject] -> ()))
		-> Self {

		return self.request(path, success: success)
	}

	public func list(path: String, success: ([[String: AnyObject]] -> ()))
		-> Self {

		return self.request(path, success: success)
	}

	public func request<T>(
			path: String, success: (T -> ()), method: String = "GET")
		-> Self {

		let URL = NSURL(string: self.server + path)!
		let request = NSMutableURLRequest(URL: URL)
		request.HTTPMethod = method

		let session = NSURLSession.sharedSession()

		session.dataTaskWithRequest(
			request,
			completionHandler: { (data, response, error) in
				let httpResponse = response as NSHTTPURLResponse
				let status = httpResponse.statusCode

				if (status == 204) {
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