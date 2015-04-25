import XCTest

class PromiseTest : XCTestCase {

	func testThenOrder() {
		let expectation = expectationWithDescription("testThen")
		var order = [String]()

		Promise({
			order.append("one")
		}).then({
			order.append("two")
		}).then({
			order.append("three")
			expectation.fulfill()
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

		Promise({
			return "one"
		}).then(both: { input in
			output.append(input as! String)
			return "two"
		}).then(both: { input in
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