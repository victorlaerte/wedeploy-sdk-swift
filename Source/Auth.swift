import Foundation

public class Auth {

	public var password: String
	public var username: String

	public init(_ username: String, _ password: String) {
		self.username = username
		self.password = password
	}

}