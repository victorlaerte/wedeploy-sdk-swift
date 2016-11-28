import Foundation


public struct OAuth: Auth {

	public let token: String
	
	public func authenticate(request: Request) {
		let bearer = "Bearer \(token)"

		request.headers["Authorization"] = bearer
	}
}
