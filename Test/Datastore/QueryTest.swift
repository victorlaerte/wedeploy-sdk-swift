import XCTest

class QueryTest : BaseTest {

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