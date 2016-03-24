@testable import Launchpad
import XCTest

class AuthenticationTest: XCTestCase {

	let username = "igor.matos@liferay.com"
	let password = "weloveliferay"
	let url = "http://liferay.io/launchpad/swift/artists"
	var artists = [[String: AnyObject]]()
	var artistsToAdd = [
		[
			"name": "Rage Against The Machine",
			"genre": "Rock / Rap Rock"
		],
		[
			"name": "Led Zeppelin",
			"genre": "Classic Rock"
		]
	]

	override func tearDown() {
		deleteAllArtists()
	}

	override func setUp() {
		deleteAllArtists()

		for artistToAdd in artistsToAdd {
			let expectation = expect("setUp")

			Launchpad
				.url(url)
				.auth(Auth(username, password))
				.post(artistToAdd)
				.then { response in
					self.artists.append(response.body as! [String: AnyObject])
					expectation.fulfill()
				}
				.done()

			wait()
		}

	}

	private func deleteAllArtists() {
		let expectation = expect("tearDown")

		Launchpad
			.url(url)
			.auth(Auth(username, password))
			.delete()
			.then { status -> () in
				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testAuthSuccess(){
		let expectation = expect("auth")

		Launchpad
			.url(url)
			.auth(Auth(username, password))
			.get()
			.then { response in
				guard let queryResponse = response.body as? [[String: AnyObject]] else {
					return
				}

				XCTAssertEqual(queryResponse.count, 2)
				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testAuthFail(){
		let expectation = expect("auth")

		Launchpad
			.url(url)
			.auth(Auth(username, "anypassword"))
			.get()
			.then { response in
				XCTAssertEqual(response.statusCode, 401)
				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testApiWithoutAuth(){
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