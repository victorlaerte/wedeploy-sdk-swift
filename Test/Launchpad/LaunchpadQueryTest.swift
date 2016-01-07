import Launchpad
import XCTest

class LaunchpadQueryTest : BaseTest {

	func testCount() {
		let expectation = expect("count")
		let query = Query().count()

		launchpad
			.params(query.params)
			.get()
			.then { response in
				XCTAssertTrue(response.succeeded)
				XCTAssertEqual(2, response.body as? Int)
				expectation.fulfill()
			}
			.done();

		wait()
	}

}