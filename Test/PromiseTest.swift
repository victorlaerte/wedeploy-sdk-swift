import XCTest

class PromiseTest : XCTestCase {

	func testThen() {
		let expectation = expectationWithDescription("testThen")
		var results = [String]()

		Promise().then({
			results.append("one")
		}).then({
			results.append("two")
			expectation.fulfill()
		}).done()

		wait {
			XCTAssertEqual(2, results.count)
			XCTAssertEqual("one", results.first!)
			XCTAssertEqual("two", results.last!)
		}
	}

}