import XCTest

class Fulfill : XCTestCase {

	func testFulfill() {
		let expectation = expectationWithDescription("testFulfill")
		var output = [String]()

		Promise<String>(promise: { (fulfill, reject) in
			let queue = dispatch_get_global_queue(
				DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

			dispatch_async(queue, {
				fulfill("one")
			})
		})
		.then({
			output.append($0)
			return "two"
		})
		.then({
			output.append($0)
			expectation.fulfill()
			return "three"
		} as String -> String)
		.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

}