import Launchpad
import XCTest

class LaunchpadQueryTest : BaseTest {

	func testCount() {
		let expectation = expect("count")
		let query = Query().count()

		launchpad
			.path(path)
			.params(query.params)
			.get({ response in
				XCTAssertTrue(response.succeeded)
				XCTAssertEqual(2, response.body as? Int)
				expectation.fulfill()
			})

		wait()
	}

}