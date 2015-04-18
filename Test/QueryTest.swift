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

	func testLimitRequest() {
		let expectation = expectationWithDescription("limitRequest")
		let query = Query().limit(1)

		pad.get(path, query: query) { books in
			XCTAssertEqual(1, books.count)
			self.assertBook(self.title, book: books.first!)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testSort() {
		let query = Query().sort("title")
		XCTAssertEqual("{\"sort\":[{\"title\":\"asc\"}]}", query.description)

		query.sort("author", order: Query.Order.DESC)

		XCTAssertEqual(
			"{\"sort\":[{\"title\":\"asc\"},{\"author\":\"desc\"}]}",
			query.description)
	}

}