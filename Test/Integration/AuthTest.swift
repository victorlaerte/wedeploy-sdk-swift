@testable import Launchpad
import XCTest

class AuthTest : XCTestCase {

	var password: String?
	var path: String!
	var server: String!
	var username: String!

	let basicHeader = "Basic YnJ1bm8uZmFyYWNoZUBsaWZlcmF5LmNvbTp0ZXN0"

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

	func testGetWithAuth() {
		let expectation = expect("auth")
		let transport = MockTransport()

		Launchpad
			.url(server)
			.path(path)
			.auth(BasicAuth(username, "test"))
			.use(transport)
			.get()
			.then { response in
				XCTAssertEqual(
					self.basicHeader,
					transport.request!.headers["Authorization"])

				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testDeleteWithAuth() {
		let expectation = expect("auth")
		let transport = MockTransport()

		Launchpad
			.url(server)
			.path(path)
			.auth(BasicAuth(username, "test"))
			.use(transport)
			.delete()
			.then { response in
				XCTAssertEqual(
					self.basicHeader,
					transport.request!.headers["Authorization"])

				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testPatchWithAuth() {
		let expectation = expect("auth")
		let transport = MockTransport()

		Launchpad
			.url(server)
			.path(path)
			.auth(BasicAuth(username, "test"))
			.use(transport)
			.patch(nil)
			.then { response in
				XCTAssertEqual(
					self.basicHeader,
					transport.request!.headers["Authorization"])

				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testPostWithAuth() {
		let expectation = expect("auth")
		let transport = MockTransport()

		Launchpad
			.url(server)
			.path(path)
			.auth(BasicAuth(username, "test"))
			.use(transport)
			.post(nil)
			.then { response in
				XCTAssertEqual(
					self.basicHeader,
					transport.request!.headers["Authorization"])

				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testPutWithAuth() {
		let expectation = expect("auth")
		let transport = MockTransport()

		Launchpad
			.url(server)
			.path(path)
			.auth(BasicAuth(username, "test"))
			.use(transport)
			.put(nil)
			.then { response in
				XCTAssertEqual(
					self.basicHeader,
					transport.request!.headers["Authorization"])

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

		XCTAssertEqual(basicHeader, request.headers["Authorization"])
	}

}

class MockTransport : Transport {

	var request : Request?

	func send(
		request: Request, success: (Response -> ())?,
		failure: (NSError -> ())?) {

		self.request = request

		let data = "".dataUsingEncoding(NSUTF8StringEncoding)
		success!(Response(statusCode: 200, headers: [:], body: data!))
	}

}