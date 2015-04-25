import XCTest

class PromiseTest : XCTestCase {

	func testThenOrder() {
		let expectation = expectationWithDescription("testThen")
		var order = [String]()

		Promise({ input in
			order.append("one")
			return ""
		}).then({ input in
			order.append("two")
			return ""
		}).then({ input in
			order.append("three")
			expectation.fulfill()
			return ""
		}).done()

		wait {
			XCTAssertEqual(3, order.count)
			XCTAssertEqual("one", order.first!)
			XCTAssertEqual("two", order[1])
			XCTAssertEqual("three", order.last!)
		}
	}

	func testThenWithOutput() {
		let expectation = expectationWithDescription("testThen")
		var output = [String]()

		Promise({ input in
			return "one"
		}).then({ input in
			output.append(input as! String)
			return "two"
		}).then({ input in
			output.append(input as! String)
			expectation.fulfill()
			return "three"
		}).done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

}