import Launchpad
import XCTest

class QueryTest : XCTestCase {

	func testComplex_Query() {
		let query = Query()
			.filter(Filter.gt("age", 12))
			.sort("age", order: Query.Order.DESC)
			.sort("name")
			.offset(5)
			.limit(10)
			.fetch()

		assertJSON("{" +
			"\"limit\":10," +
			"\"sort\":[{\"age\":\"desc\"},{\"name\":\"asc\"}]," +
			"\"offset\":5," +
			"\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]," +
			"\"type\":\"fetch\"" +
			"}",
			query.query)
	}

	func testFilter_With_Instance() {
		let query = Query().filter(Filter.gt("age", 12))

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]}",
			query.query)
	}

	func testFilter_With_Multiple_Filters() {
		let query = Query()
			.filter(Filter.gt("age", 12))
			.filter("age", "<", 15)
			.filter("name", "Foo")

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}," +
			"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
			"{\"name\":{\"operator\":\"=\",\"value\":\"Foo\"}}]}",
			query.query)
	}

	func testFilter_With_Operator() {
		let query = Query().filter("age", ">", 12)

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]}",
			query.query)
	}

	func testFilter_With_Optional_Operator() {
		let query = Query().filter("age", 12)

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\"=\",\"value\":12}}]}",
			query.query)
	}

	func testOffset() {
		let query = Query().offset(5)
		assertJSON("{\"offset\":5}", query.query)
	}

	func testLimit() {
		let query = Query().limit(10)
		assertJSON("{\"limit\":10}", query.query)
	}

	func testSort() {
		let query = Query().sort("title")
		XCTAssertEqual("{\"sort\":[{\"title\":\"asc\"}]}", query.description)

		query.sort("author", order: Query.Order.DESC)

		assertJSON(
			"{\"sort\":[{\"title\":\"asc\"},{\"author\":\"desc\"}]}",
			query.query)
	}

	func testType_Count() {
		let query = Query().count()
		assertJSON("{\"type\":\"count\"}", query.query)
	}

	func testType_Fetch() {
		let query = Query().fetch()
		assertJSON("{\"type\":\"fetch\"}", query.query)
	}

}