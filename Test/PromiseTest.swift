import XCTest

class PromiseTest : XCTestCase {

	var timeout = 1 as Double

	func testThen() {
		let expectation = expectationWithDescription("testThen")
		var results = [String]()

		Promise().then({
			results.append("one")
		}).then({
			results.append("two")
			expectation.fulfill()
		}).done()

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)

			XCTAssertEqual(2, results.count)
			XCTAssertEqual("one", results.first!)
			XCTAssertEqual("two", results.last!)
		}
	}

	func hasError(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

}