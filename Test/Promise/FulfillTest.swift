import XCTest

class Fulfill : XCTestCase {

	func testFulfill() {
		let expectation = expectationWithDescription("testFulfill")
		var output = [String]()

		Promise<String>({ (fulfill, reject) in
			let queue = dispatch_get_global_queue(
				DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

			dispatch_async(queue, {
				fulfill("one")
			})
		}).then(block: {input in
			output.append(input!)
			return "two"
		}).then(block: {input in
			output.append(input!)
			return "two"
		})
		.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

}