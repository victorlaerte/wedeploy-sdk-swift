import Launchpad
import XCTest

class FilterTest : XCTestCase {

	func testAnd() {
		let filter = Filter
			.gt("age", 12)
			.and(Filter.lt("age", 15))

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.filter)
	}

	func testAnd_Overloaded_Operator() {
		let filter = Filter
			.gt("age", 12) &&
			Filter.lt("age", 15) &&
			"name = foo"

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testAnd_With_Three_Filters() {
		let filter = Filter
			.gt("age", 12)
			.and(Filter.lt("age", 15))
			.and(Filter.equal("name", "foo"))

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testAny() {
		let filter = Filter.any("age", [12, 21, 25])

		assertJSON(
			"{\"age\":{\"operator\":\"any\",\"value\":[12,21,25]}}",
			filter.filter)
	}

	func testComposition() {
		let filter = Filter
			.gt("age", 12)
			.or("age < 15" as Filter)
			.and(Filter("name = foo"))

		assertJSON(
			"{\"and\":[" +
				"{\"or\":[" +
					"{\"age\":{\"operator\":\">\",\"value\":12}}," +
					"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
				"]}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testCustom() {
		let filter = Filter("age", ">", 12)
		assertJSON("{\"age\":{\"operator\":\">\",\"value\":12}}", filter.filter)
	}

	func testDefaultOperator() {
		let filter = Filter("age", 12)
		assertJSON("{\"age\":{\"operator\":\"=\",\"value\":12}}", filter.filter)
	}

	func testEqual() {
		let filter = Filter.equal("age", 12)
		assertJSON("{\"age\":{\"operator\":\"=\",\"value\":12}}", filter.filter)
	}

	func testGt() {
		let filter = Filter.gt("age", 12)
		assertJSON("{\"age\":{\"operator\":\">\",\"value\":12}}", filter.filter)
	}

	func testGte() {
		let filter = Filter.gte("age", 12)
		assertJSON(
			"{\"age\":{\"operator\":\">=\",\"value\":12}}", filter.filter)
	}

	func testLt() {
		let filter = Filter.lt("age", 12)
		assertJSON("{\"age\":{\"operator\":\"<\",\"value\":12}}", filter.filter)
	}

	func testLte() {
		let filter = Filter.lte("age", 12)

		assertJSON(
			"{\"age\":{\"operator\":\"<=\",\"value\":12}}",
			filter.filter)
	}

	func testNone() {
		let filter = Filter.none("age", [12, 21, 25])

		assertJSON(
			"{\"age\":{\"operator\":\"none\",\"value\":[12,21,25]}}",
			filter.filter)
	}

	func testNot() {
		let filter = Filter("age", 12).not()

		assertJSON(
			"{\"not\":{\"age\":{\"operator\":\"=\",\"value\":12}}}",
			filter.filter)
	}

	func testNot_With_Operation() {
		let filter = !Filter("age", 12)

		assertJSON(
			"{\"not\":{\"age\":{\"operator\":\"=\",\"value\":12}}}",
			filter.filter)
	}

	func testNotEqual() {
		let filter = Filter.notEqual("age", 12)

		assertJSON(
			"{\"age\":{\"operator\":\"!=\",\"value\":12}}", filter.filter)
	}

	func testOr() {
		let filter = Filter
			.gt("age", 12)
			.or(Filter.lt("age", 15))

		assertJSON(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.filter)
	}

	func testOr_Overloaded_Operator() {
		let filter = Filter
			.gt("age", 12) ||
			Filter.lt("age", 15) ||
			"name = foo"

		assertJSON(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testOr_With_Three_Filters() {
		let filter = Filter
			.gt("age", 12)
			.or(Filter.lt("age", 15))
			.or(Filter.equal("name", "foo"))

		assertJSON(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testRegex() {
		let filter = Filter.regex("age", 12)
		assertJSON("{\"age\":{\"operator\":\"~\",\"value\":12}}", filter.filter)
	}

	func testStringConvertible() {
		let filter: Filter = "age > 12"
		assertJSON("{\"age\":{\"operator\":\">\",\"value\":12}}", filter.filter)
	}

	func testStringConvertible_With_And_Operator() {
		let filter = Filter
			.gt("age", 12) &&
			"age < 15"

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.filter)
	}

	func testStringConvertible_With_String_Value() {
		let filter: Filter = "name = foo"

		assertJSON(
			"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}", filter.filter)
	}

}