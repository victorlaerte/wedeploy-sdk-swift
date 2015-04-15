import Foundation

public class Launchpad {

	let server: String

	init(server: String) {
		self.server = server
	}

	public func get(path: String, success: ([String: AnyObject] -> ()))
		-> Self {

		return self.request(path, success)
	}

	public func list(path: String, success: ([[String: AnyObject]] -> ()))
		-> Self {

		return self.request(path, success)
	}

	public func request<T>(path: String, success: (T -> ()))
		-> Self {

		let URL = NSURL(string: self.server + path)!
		let session = NSURLSession.sharedSession()

		session.dataTaskWithURL(
			URL,
			completionHandler: { (data, response, error) in
				let result = NSJSONSerialization.JSONObjectWithData(
					data, options: NSJSONReadingOptions.AllowFragments,
					error: nil) as T

				success(result)
			}
		).resume()

		return self
	}

}