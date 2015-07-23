import XCTest

class FilterTest : BaseTest {

	func testAnd() {
		let filter = Filter.gt("age", 12).and(Filter.lt("age", 15))

		XCTAssertEqual(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.description)
	}

	func testAnd_Overloaded_Operator() {
		let filter = Filter.gt("age", 12) && Filter.lt("age", 15) &&
			Filter.equal("name", "foo")

		XCTAssertEqual(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.description)
	}

	func testAnd_With_Three_Filters() {
		let filter = Filter
			.gt("age", 12)
			.and(Filter.lt("age", 15))
			.and(Filter.equal("name", "foo"))

		XCTAssertEqual(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.description)
	}

	func testAnd_With_Tuples() {
		let filter = Filter
			.gt("age", 12)
			.and(("age", "<", 15), ("name", "=", "foo"))

		XCTAssertEqual(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.description)
	}

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