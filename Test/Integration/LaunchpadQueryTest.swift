import Launchpad
import XCTest

class LaunchpadQueryTest : BaseTest {

	func testCount() {
		let expectation = expect("count")
		let query = Query().count()

		launchpad
			.params(query.params)
			.get()
			.then { response in
				XCTAssertTrue(response.succeeded)
				XCTAssertEqual(2, response.body as? Int)
				expectation.fulfill()
			}
			.done();

		wait()
	}

	func testFilter_Year() {
		let expectation = expect("filter")
		let query = Query().filter("year", self.booksToAdd.first!["year"]!)

		launchpad
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