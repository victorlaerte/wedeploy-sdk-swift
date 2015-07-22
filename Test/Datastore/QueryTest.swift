import XCTest

class QueryTest : BaseTest {

	func testComplex_Query() {
		let query = Query()
			.filter(Filter.gt("age", 12))
			.sort("age", order: Query.Order.DESC)
			.sort("name")
			.from(5)
			.limit(10)
			.fetch()

		XCTAssertEqual("{" +
			"\"limit\":10," +
			"\"sort\":[{\"age\":\"desc\"},{\"name\":\"asc\"}]," +
			"\"offset\":5," +
			"\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]," +
			"\"type\":\"fetch\"" +
			"}",
			query.description)
	}

	func testFilter_With_Instance() {
		let query = Query().filter(Filter.gt("age", 12))

		XCTAssertEqual(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]}",
			query.description)
	}

	func testFilter_With_Multiple_Filters() {
		let query = Query()
			.filter(Filter.gt("age", 12))
			.filter("age", "<", 15)
			.filter("name", "Foo")

		XCTAssertEqual(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}," +
			"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
			"{\"name\":{\"operator\":\"=\",\"value\":\"Foo\"}}]}",
			query.description)
	}

	func testFilter_With_Operator() {
		let query = Query().filter("age", ">", 12)

		XCTAssertEqual(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]}",
			query.description)
	}

	func testFilter_With_Optional_Operator() {
		let query = Query().filter("age", 12)

		XCTAssertEqual(
			"{\"filter\":[{\"age\":{\"operator\":\"=\",\"value\":12}}]}",
			query.description)
	}

	func testOffset() {
		let query = Query().from(5)
		XCTAssertEqual("{\"offset\":5}", query.description)
	}

	func testLimit() {
		let query = Query().limit(10)
		XCTAssertEqual("{\"limit\":10}", query.description)
	}

	func testSort() {
		let query = Query().sort("title")
		XCTAssertEqual("{\"sort\":[{\"title\":\"asc\"}]}", query.description)

		query.sort("author", order: Query.Order.DESC)

		XCTAssertEqual(
			"{\"sort\":[{\"title\":\"asc\"},{\"author\":\"desc\"}]}",
			query.description)
	}

	func testType_Count() {
		let query = Query().count()
		XCTAssertEqual("{\"type\":\"count\"}", query.description)
	}

	func testType_Custom() {
		let query = Query().type("customType")
		XCTAssertEqual("{\"type\":\"customType\"}", query.description)
	}

	func testType_Fetch() {
		let query = Query().fetch()
		XCTAssertEqual("{\"type\":\"fetch\"}", query.description)
	}

	func testType_Scan() {
		let query = Query().scan()
		XCTAssertEqual("{\"type\":\"scan\"}", query.description)
	}

}