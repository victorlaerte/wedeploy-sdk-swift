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
import later
import XCTest

class LaunchpadTest : BaseTest {

	func testAdd() {
		let expectation = expect("add")
		let bookToAdd = booksToAdd.first!

		launchpad
			.post(bookToAdd)
			.then { response in
				self.assertBook(bookToAdd, response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testAdd_Then_Update_Then_Remove() {
		let expectation = expect("add")
		var bookToAdd = booksToAdd.first!

		launchpad
			.post(bookToAdd)

			.then { response -> Promise<Response> in
				let book = self.assertBook(bookToAdd, response: response)
				bookToAdd["title"] = "La fiesta del chivo"
				let id = book!["id"] as! String

				return self.launchpad
					.path("/\(id)")
					.put(bookToAdd)
			}

			.then { response -> Promise<Response> in
				let updatedBook = self.assertBook(bookToAdd, response: response)
				let id = updatedBook!["id"]! as! String

				return self.launchpad
					.path("/\(id)")
					.delete()
			}

			.then { response in
				XCTAssertTrue(response.succeeded)
				XCTAssertEqual(204, response.statusCode)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testGet() {
		let expectation = expect("get")

		guard let book = books.first else {
			return
		}

		let id = book["id"] as! String

		launchpad
			.path("/\(id)")
			.get()
			.then { response in
				self.assertBook(self.booksToAdd.first!, response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testList() {
		let expectation = expect("list")

		launchpad
			.get()
			.then { response in
				self.assertBooks(self.booksToAdd, response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testMainThread() {
		let expectation = expect("mainThread")

		guard let book = books.first else {
			return
		}

		let id = book["id"] as! String

		launchpad
			.path("/\(id)")
			.get()
		.done { value, error in
			XCTAssertTrue(NSThread.isMainThread())
			expectation.fulfill()
		}

		wait()
	}

	func testDelete() {
		let expectation = expect("delete")

		guard let book = books.first else {
			return
		}

		let id = book["id"] as! String

		launchpad
			.path("/\(id)")
			.delete()
			.then { response in
				XCTAssertTrue(response.succeeded)
				XCTAssertEqual(204, response.statusCode)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testUpdate() {
		let expectation = expect("update")

		guard var book = books.first else {
			return
		}

		book["title"] = "La fiesta del chivo"

		let id = book["id"] as! String

		launchpad
			.path("/\(id)")
			.put(book)
			.then { response in
				self.assertBook(book, response: response)
				expectation.fulfill()
			}
		.done()

		wait()
	}

}
