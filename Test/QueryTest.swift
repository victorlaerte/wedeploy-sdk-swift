import XCTest

class QueryTest : BaseTest {

	func testOffset() {
		let query = Query().offset(5)
		XCTAssertEqual("{\"offset\":5}", query.description)
	}

	func testLimit() {
		let query = Query().limit(10)
		XCTAssertEqual("{\"limit\":10}", query.description)
	}

}