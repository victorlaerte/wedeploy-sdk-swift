import XCTest

class FilterTest : BaseTest {

	func testAnd() {
		let filter = Filter
			.gt("age", 12)
			.and(Filter.lt("age", 15))

		XCTAssertEqual(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.description)
	}

	func testAnd_Overloaded_Operator() {
		let filter = Filter
			.gt("age", 12) &&
			Filter.lt("age", 15) &&
			"name = foo"

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

	func testAny() {
		let filter = Filter.any("age", [12, 21, 25])

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"any\",\"value\":[12,21,25]}}",
			filter.description)
	}

	func testComposition() {
		let filter = Filter
			.gt("age", 12)
			.or("age < 15" as Filter)
			.and(Filter("name = foo"))

		XCTAssertEqual(
			"{\"and\":[" +
				"{\"or\":[" +
					"{\"age\":{\"operator\":\">\",\"value\":12}}," +
					"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
				"]}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
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
			"{\"age\":{\"operator\":\"none\",\"value\":[12,21,25]}}",
			filter.description)
	}

	func testNot() {
		let filter = Filter("age", 12).not()

		XCTAssertEqual(
			"{\"not\":{\"age\":{\"operator\":\"=\",\"value\":12}}}",
			filter.description)
	}

	func testNot_With_Operation() {
		let filter = !Filter("age", 12)

		XCTAssertEqual(
			"{\"not\":{\"age\":{\"operator\":\"=\",\"value\":12}}}",
			filter.description)
	}

	func testNotEqual() {
		let filter = Filter.notEqual("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"!=\",\"value\":12}}", filter.description)
	}

	func testOr() {
		let filter = Filter
			.gt("age", 12)
			.or(Filter.lt("age", 15))

		XCTAssertEqual(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.description)
	}

	func testOr_Overloaded_Operator() {
		let filter = Filter
			.gt("age", 12) ||
			Filter.lt("age", 15) ||
			"name = foo"

		XCTAssertEqual(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.description)
	}

	func testOr_With_Three_Filters() {
		let filter = Filter
			.gt("age", 12)
			.or(Filter.lt("age", 15))
			.or(Filter.equal("name", "foo"))

		XCTAssertEqual(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.description)
	}

	func testRegex() {
		let filter = Filter.regex("age", 12)

		XCTAssertEqual(
			"{\"age\":{\"operator\":\"~\",\"value\":12}}", filter.description)
	}

	func testStringConvertible() {
		let filter: Filter = "age > 12"

		XCTAssertEqual(
			"{\"age\":{\"operator\":\">\",\"value\":12}}",
			filter.description)
	}

	func testStringConvertible_With_And_Operator() {
		let filter = Filter
			.gt("age", 12) &&
			"age < 15"

		XCTAssertEqual(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.description)
	}

	func testStringConvertible_With_String_Value() {
		let filter: Filter = "name = foo"

		XCTAssertEqual(
			"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}",
			filter.description)
	}

}