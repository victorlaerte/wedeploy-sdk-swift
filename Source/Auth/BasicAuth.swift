import Foundation

public class BasicAuth : Auth {

	public var password: String
	public var username: String

	public init(_ username: String, _ password: String) {
		self.username = username
		self.password = password
	}

	public func authenticate(request: Request) {
		var credentials = "\(username):\(password)"
		let data = credentials.data(using: .utf8)
		credentials = data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))

		request.headers["Authorization"] = "Basic " + credentials
	}

}
