@testable import Launchpad
import XCTest

class AuthTest : XCTestCase {

	var password: String?
	var path: String!
	var server: String!
	var username: String!

	override func setUp() {
		let bundle = NSBundle(identifier: "com.liferay.Launchpad.Tests")
		let file = bundle!.pathForResource("settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: file!) as! [String: String]

		password = settings["password"]
		path = settings["protectedPath"]
		server = settings["server"]
		username = settings["username"]
	}

	func testCorrectPassword() {
		guard let p = password else {
			return
		}

		let expectation = expect("auth")

		Launchpad
			.url(server)
			.path(path)
			.auth(BasicAuth(username, p))
			.get()
			.then { response in
				XCTAssertEqual(response.statusCode, 200)
				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testWrongPassword() {
		let expectation = expect("auth")

		Launchpad
			.url(server)
			.path(path)
			.auth(BasicAuth(username, "wrong"))
			.get()
			.then { response in
				XCTAssertEqual(response.statusCode, 401)
				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testMissingAuth() {
		let expectation = expect("auth")

		Launchpad
			.url(server)
			.path(path)
			.get()
			.then { response in
				XCTAssertEqual(response.statusCode, 404)
				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testBasicHeader() {
		let request = Request(headers: [:], url: "", params: [])
		let auth = BasicAuth(username, "test")
		auth.authenticate(request)

		XCTAssertEqual(
			"Basic YnJ1bm8uZmFyYWNoZUBsaWZlcmF5LmNvbTp0ZXN0",
			request.headers["Authorization"])
	}

}