import Foundation

public class Response {

	var body: AnyObject?
	let headers: [String: String]
	let statusCode: Int

	var contentType: String? {
		return headers["Content-Type"]
	}

	var succeeded: Bool {
		return (statusCode >= 200) && (statusCode <= 399)
	}

	init(statusCode: Int, headers: [String: String], body: NSData) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = parse(body)
	}

	func parse(body: NSData) -> AnyObject? {
		var parsed: AnyObject?

		if (contentType?.rangeOfString("application/json") != nil) {
			var error: NSError?

			let parsed: AnyObject? = NSJSONSerialization.JSONObjectWithData(
				body, options: NSJSONReadingOptions.AllowFragments,
				error: &error)

			if let e = error {
				return parseString(body)
			}
			else {
				return parsed
			}
		}
		else {
			return parseString(body)
		}
	}

	func parseString(body: NSData) -> NSString? {
		var string: NSString?

		if (body.length > 0) {
			string = NSString(data: body, encoding: NSUTF8StringEncoding)
		}

		return string
	}

}