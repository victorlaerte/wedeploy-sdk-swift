import Launchpad
import XCTest

class DatastoreQueryTest : BaseTest {

	func testFilter_Year() {
		let expectation = expect("filter")
		let query = Query().filter("year", self.booksToAdd.first!["year"]!)

		launchpad
			.path(path)
			.params(query.params)
			.get()
			.then { response in
				self.assertBooks([self.booksToAdd.first!], response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testFilter_Year_Greater_Than() {
		let expectation = expect("filter")
		let query = Query().filter(
			Filter.gt("year", self.booksToAdd.last!["year"]!))

		launchpad
			.path(path)
			.params(query.params)
			.get()
			.then { response in
				self.assertBooks([self.booksToAdd.first!], response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testLimit() {
		let expectation = expect("limit")
		let query = Query().limit(1)

		launchpad
			.path(path)
			.params(query.params)
			.get()
			.then { response in
				self.assertBooks([self.booksToAdd.first!], response: response)
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

		launchpad
			.path(path)
			.params(query.params)
			.get()
			.then { response in
				self.assertBooks(sortedBooks, response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

}