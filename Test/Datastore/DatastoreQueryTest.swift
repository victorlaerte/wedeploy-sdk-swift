import XCTest

class DatastoreQueryTest : BaseTest {

	func testLimit() {
		let expectation = expect("limitRequest")
		let query = Query().limit(1)

		datastore
			.get(path, query: query)
			.then { (books) -> () in
				XCTAssertEqual(1, books.count)
				self.assertBook(self.booksToAdd.first!, result: books.first!)
				expectation.fulfill()
			}
			.done()

		wait()
	}

	func testSort() {
		let expectation = expect("sortRequest")
		let query = Query().sort("title", order: Query.Order.DESC)
		let sortedBooks = sorted(self.booksToAdd, {$0["title"] > $1["title"]})

		datastore
			.get(path, query: query)
			.then { (books) -> () in
				XCTAssertEqual(self.booksToAdd.count, books.count)
				self.assertBooks(sortedBooks, result: books)
				expectation.fulfill()
			}
			.done()

		wait()
	}

}