import Launchpad
import XCTest

class LaunchpadQueryTest : BaseTest {

	func testCount() {
		let expectation = expect("count")

		launchpad
			.count()
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

		launchpad
			.filter("year", self.booksToAdd.first!["year"]!)
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

		launchpad
			.filter(Filter.gt("year", self.booksToAdd.last!["year"]!))
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

		launchpad
			.limit(1)
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
		let sortedBooks = booksToAdd.sort({
			$0["title"] as! String > $1["title"] as! String
		})

		launchpad
			.sort("title", order: Query.Order.DESC)
			.get()
			.then { response in
				self.assertBooks(sortedBooks, response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

}