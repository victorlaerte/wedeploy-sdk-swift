import XCTest

class FilterTest : BaseTest {

	func testAny() {
		let filter = Filter.any("age", [12, 21, 25])

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"in\",\"value\":[12,21,25]}}",
			filter.description)
	}

	func testCustom() {
		let filter = Filter("age", ">", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\">\",\"value\":12}}", filter.description)
	}

	func testDefaultOperator() {
		let filter = Filter("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"=\",\"value\":12}}", filter.description)
	}

	func testEqual() {
		let filter = Filter.equal("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"=\",\"value\":12}}", filter.description)
	}

	func testGt() {
		let filter = Filter.gt("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\">\",\"value\":12}}", filter.description)
	}

	func testGte() {
		let filter = Filter.gte("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\">=\",\"value\":12}}", filter.description)
	}

	func testLt() {
		let filter = Filter.lt("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"<\",\"value\":12}}", filter.description)
	}

	func testLte() {
		let filter = Filter.lte("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"<=\",\"value\":12}}", filter.description)
	}

	func testNone() {
		let filter = Filter.none("age", [12, 21, 25])

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"nin\",\"value\":[12,21,25]}}",
			filter.description)
	}

	func testNotEqual() {
		let filter = Filter.notEqual("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"!=\",\"value\":12}}", filter.description)
	}

	func testRegex() {
		let filter = Filter.regex("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"~\",\"value\":12}}", filter.description)
	}

}