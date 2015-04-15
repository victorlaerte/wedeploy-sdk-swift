import Foundation

public class Launchpad {

	let server: String

	init(server: String) {
		self.server = server
	}

	public func get(path: String, success: ([String: AnyObject] -> ()))
		-> Self {

		let URL = NSURL(string: self.server + path)!
		let session = NSURLSession.sharedSession()

		session.dataTaskWithURL(
			URL,
			completionHandler: { (data, response, error) in
				let collection = NSJSONSerialization.JSONObjectWithData(
					data, options: NSJSONReadingOptions.AllowFragments,
					error: nil) as [String: AnyObject]

				success(collection)
			}
		).resume()
		
		return self
	}

	public func list(path: String, success: ([[String: AnyObject]] -> ()))
		-> Self {

		let URL = NSURL(string: self.server + path)!
		let session = NSURLSession.sharedSession()

		session.dataTaskWithURL(
			URL,
			completionHandler: { (data, response, error) in
				let collection = NSJSONSerialization.JSONObjectWithData(
					data, options: NSJSONReadingOptions.AllowFragments,
					error: nil) as [[String: AnyObject]]

				success(collection)
			}
		).resume()

		return self
	}

}