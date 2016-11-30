/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/

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
