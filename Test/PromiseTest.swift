import XCTest

class PromiseTest : XCTestCase {

	func test_Both_Then_Both() {
		let expectation = expectationWithDescription("test_Both_Then_Both")
		var output = [String]()

		Promise({
			return "one"
		})
		.then(block: { input in
			output.append(input!)
			return "two"
		})
		.then(block: { input in
			output.append(input!)
			expectation.fulfill()
			return "three"
		})
		.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

	func test_Both_Then_Empty() {
		let expectation = expectationWithDescription("test_Both_Then_Empty")
		var output = [String]()

		Promise({
			return "one"
		})
		.then(block: { input in
			output.append(input!)
			return "two"
		})
		.then({
			expectation.fulfill()
		})
		.done()

		wait {
			XCTAssertEqual(1, output.count)
			XCTAssertEqual("one", output.first!)
		}
	}

	func test_Empty_Then_Both() {
		let expectation = expectationWithDescription("test_Empty_Then_Both")
		var output = [String]()

		Promise({
			return "one"
		})
		.then({
			output.append("two")
		})
		.then(block: { input in
			expectation.fulfill()
			return ""
		})
		.done()

		wait {
			XCTAssertEqual(1, output.count)
			XCTAssertEqual("two", output.first!)
		}
	}

	func test_Empty_Then_Empty() {
		let expectation = expectationWithDescription("test_Empty_Then_Empty")
		var order = [String]()

		Promise({
			order.append("one")
		})
		.then({
			order.append("two")
		})
		.then({
			order.append("three")
			expectation.fulfill()
		})
		.done()

		wait {
			XCTAssertEqual(3, order.count)
			XCTAssertEqual("one", order.first!)
			XCTAssertEqual("two", order[1])
			XCTAssertEqual("three", order.last!)
		}
	}

	func test_Different_Return_Types() {
		let expectation = expectationWithDescription(
			"test_Different_Return_Types")

		var output = [String]()

		Promise({
			return "one"
		})
		.then(block: { input in
			return ["two"]
		})
		.then(block: { input in
			XCTAssertEqual(1, input!.count)
			XCTAssertEqual("two", input!.first!)
			expectation.fulfill()
			return nil
		})
		.done()

		wait()
	}

}