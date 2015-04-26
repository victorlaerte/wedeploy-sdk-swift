import XCTest

class ThenTest : XCTestCase {

	func test_Returns_Array_Then_Empty() {
		let expectation = expect("test_Returns_Array_Then_Empty")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then {
			return [$0, "two"]
		}
		.then { (value) -> () in
			XCTAssertEqual(2, value.count)
			XCTAssertEqual("one", value.first!)
			XCTAssertEqual("two", value.last!)
			expectation.fulfill()
		}

		p.done()
		
		wait()
	}

	func test_Returns_Empty_Then_Empty() {
		let expectation = expect("test_Returns_Empty_Then_Empty")
		var order = [String]()

		let p = Promise {
			order.append("one")
		}
		.then {
			order.append("two")
		}
		.then { () -> () in
			order.append("three")
			expectation.fulfill()
		}

		p.done()

		wait {
			XCTAssertEqual(3, order.count)
			XCTAssertEqual("one", order.first!)
			XCTAssertEqual("two", order[1])
			XCTAssertEqual("three", order.last!)
		}
	}

	func test_Returns_Empty_Then_String() {
		let expectation = expect("test_Returns_Empty_Then_String")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then {
			output.append("two")
		}
		.then { () -> String in
			expectation.fulfill()
			return "three"
		}

		p.done()

		wait {
			XCTAssertEqual(1, output.count)
			XCTAssertEqual("two", output.first!)
		}
	}

	func test_Returns_String_Then_Empty() {
		let expectation = expect("test_Returns_String_Then_Empty")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then { (value) -> String in
			output.append(value)
			return "two"
		}
		.then { (value) -> () in
			output.append(value)
			expectation.fulfill()
		}

		p.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

	func test_Returns_String_Then_String() {
		let expectation = expect("test_Returns_String_Then_String")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then { (value) -> String in
			output.append(value)
			return "two"
		}
		.then { (value) -> String in
			output.append(value)
			expectation.fulfill()
			return "three"
		}

		p.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

}