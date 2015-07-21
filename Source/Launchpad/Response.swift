import Foundation

public class Response {

	let body: NSData
	let headers: [String: String]
	let statusCode: Int

	var contentType: String? {
		return headers["Content-Type"]
	}

	var succeeded: Bool {
		return (statusCode >= 200) && (statusCode <= 399)
	}

	init(
		statusCode: Int, headers: [String: String], body: NSData) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = body
	}

	public func parse<T>(error: NSErrorPointer) -> T {
		if (contentType != "application/json; charset=UTF-8") {
			return self.statusCode as! T
		}

		return NSJSONSerialization.JSONObjectWithData(
				self.body, options: NSJSONReadingOptions.AllowFragments,
				error: error)
			as! T
	}

}