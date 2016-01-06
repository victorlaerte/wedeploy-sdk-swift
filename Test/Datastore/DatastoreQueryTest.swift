import Launchpad
import XCTest

class DatastoreQueryTest : BaseTest {

	func testFilter_Year() {
		let expectation = expect("filter")
		let query = Query().filter("year", self.booksToAdd.first!["year"]!)

		datastore
			.get(path, query: query)
			.then { books -> () in
				XCTAssertEqual(1, books.count)
				self.assertBook(self.booksToAdd.first!, result: books.first!)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testFilter_Year_Greater_Than() {
		let expectation = expect("filter")
		let query = Query().filter(
			Filter.gt("year", self.booksToAdd.last!["year"]!))

		datastore
			.get(path, query: query)
			.then { books -> () in
				XCTAssertEqual(1, books.count)
				self.assertBook(self.booksToAdd.first!, result: books.first!)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testLimit() {
		let expectation = expect("limit")
		let query = Query().limit(1)

		datastore
			.get(path, query: query)
			.then { books -> () in
				XCTAssertEqual(1, books.count)
				self.assertBook(self.booksToAdd.first!, result: books.first!)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testSort() {
		let expectation = expect("sort")
		let query = Query().sort("title", order: Query.Order.DESC)
		let sortedBooks = booksToAdd.sort({
			$0["title"] as! String > $1["title"] as! String
		})

		datastore
			.get(path, query: query)
			.then { books -> () in
				XCTAssertEqual(self.booksToAdd.count, books.count)
				self.assertBooks(sortedBooks, result: books)
				expectation.fulfill()
			}
		.done()

		wait()
	}

}