import Launchpad
import later
import XCTest

class WeDeployAuthTest : XCTestCase {

	let url = "http://auth.easley84.wedeploy.io"
	let user = "test@test.com"
	let password = "test"

	func testAuthWithDeployAuth() {

		let exp = expectation(description: "")

		Launchpad.auth(authPath: url)
			.signInWithEmailAndPassword(username: user, password: password)
			.done { response, error in
				XCTAssertNil(error)
				XCTAssertEqual(response!.statusCode, 200)
				let body = response!.body as! NSDictionary
				XCTAssertNotNil(body["access_token"])
				exp.fulfill()
			}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testWrongAuthWithDeployAuth() {

		let exp = expectation(description: "")

		Launchpad.auth(authPath: url)
			.signInWithEmailAndPassword(username: user, password: "te")
			.done { response, error in
				XCTAssertNil(error)
				XCTAssertEqual(response!.statusCode, 400)
				exp.fulfill()
		}

		waitForExpectations(timeout: 10, handler: nil)
	}
}
