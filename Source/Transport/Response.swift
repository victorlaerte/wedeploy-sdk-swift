import Foundation

public class Response {

	public private(set) var body: AnyObject?
	public let headers: [String: String]
	public let statusCode: Int

	public var contentType: String? {
		return headers["Content-Type"]
	}

	public var succeeded: Bool {
		return (statusCode >= 200) && (statusCode <= 399)
	}

	init(statusCode: Int, headers: [String: String], body: Data) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = parse(body: body)
	}

	func parse(body: Data) -> AnyObject? {
		if (contentType?.range(of: "application/json") != nil) {
			do {
				let parsed = try JSONSerialization.jsonObject(with: body, options: .allowFragments)

				return parsed as AnyObject
			}
			catch {
				return parseString(body: body) as AnyObject
			}
		}
		else {
			return parseString(body: body) as AnyObject
		}
	}

	func parseString(body: Data) -> String? {
		var string: String?

		if (body.count > 0) {
			string = String(data: body, encoding: .utf8)
		}

		return string
	}

}
