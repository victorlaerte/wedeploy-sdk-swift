import XCTest

class ThenTest : XCTestCase {

	func test_Returns_Array_Then_Empty() {
		let expectation = expect("test_Returns_Array_Then_Empty")
		var output = [String]()

		let p = Promise({
			return "one"
		})
		.then({
			return [$0, "two"]
		})
		.then({
			XCTAssertEqual(2, $0.count)
			XCTAssertEqual("one", $0.first!)
			XCTAssertEqual("two", $0.last!)
			expectation.fulfill()
		} as [String] -> ())

		p.done()
		
		wait()
	}

	func test_Returns_Empty_Then_Empty() {
		let expectation = expect("test_Returns_Empty_Then_Empty")
		var order = [String]()

		let p = Promise({
			order.append("one")
		})
		.then({
			order.append("two")
		})
		.then({
			order.append("three")
			expectation.fulfill()
		} as () -> ())

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

		let p = Promise({
			return "one"
		})
		.then({
			output.append("two")
		})
		.then({
			expectation.fulfill()
			return "three"
		} as () -> String)

		p.done()

		wait {
			XCTAssertEqual(1, output.count)
			XCTAssertEqual("two", output.first!)
		}
	}

	func test_Returns_String_Then_Empty() {
		let expectation = expect("test_Returns_String_Then_Empty")
		var output = [String]()

		let p = Promise({
			return "one"
		})
		.then({
			output.append($0)
			return "two"
		})
		.then({
			output.append($0)
			expectation.fulfill()
		} as String -> ())

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

		let p = Promise({
			return "one"
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

		p.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

}