@testable import Launchpad
import XCTest

class AuthenticationTest: XCTestCase {

	let username = "igor.matos@liferay.com"
	let password = "weloveliferay"
	let url = "http://liferay.io/launchpad/swift/artists"

	func testCorrectPassword(){
		let expectation = expect("auth")

		Launchpad
			.url(url)
			.auth(Auth(username, password))
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
			.url(url)
			.auth(Auth(username, "wrong"))
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

		Launchpad.url(url)
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
		let auth = Auth("bruno.farache@liferay.com", "test")
		auth.authenticate(request)

		XCTAssertEqual(
			"Basic YnJ1bm8uZmFyYWNoZUBsaWZlcmF5LmNvbTp0ZXN0",
			request.headers["Authorization"])
	}

}