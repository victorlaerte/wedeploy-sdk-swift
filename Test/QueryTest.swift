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
		let expectation = expect("limitRequest")
		let query = Query().limit(1)

		pad.get(path, query: query, success: { books in
			XCTAssertEqual(1, books.count)
			self.assertBook(self.booksToAdd.first!, result: books.first!)
			expectation.fulfill()
		})

		wait()
	}

	func testSort() {
		let query = Query().sort("title")
		XCTAssertEqual("{\"sort\":[{\"title\":\"asc\"}]}", query.description)

		query.sort("author", order: Query.Order.DESC)

		XCTAssertEqual(
			"{\"sort\":[{\"title\":\"asc\"},{\"author\":\"desc\"}]}",
			query.description)
	}

	func testSortRequest() {
		let expectation = expect("sortRequest")
		let query = Query().sort("title", order: Query.Order.DESC)
		let sortedBooks = sorted(self.booksToAdd, {$0["title"] > $1["title"]})

		pad.get(path, query: query, success: { books in
			XCTAssertEqual(self.booksToAdd.count, books.count)
			self.assertBooks(sortedBooks, result: books)
			expectation.fulfill()
		})

		wait()
	}

}