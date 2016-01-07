import later
import Launchpad
import XCTest

class DatastoreTest : BaseTest {

	func testAdd() {
		let expectation = expect("add")
		let bookToAdd = booksToAdd.first!

		datastore
			.add(path, document: bookToAdd)
			.then { book -> () in
				self.assertBook(bookToAdd, book: book)
				self.books.append(book)
				expectation.fulfill()
			}
		.done()

		wait()
	}

	func testAdd_Then_Update_Then_Remove() {
		let expectation = expect("add")
		var bookToAdd = booksToAdd.first!

		datastore
			.add(path, document: bookToAdd)

			.then { book -> Promise<[String: AnyObject]> in
				self.assertBook(bookToAdd, book: book)
				self.books.append(book)
				bookToAdd["title"] = "La fiesta del chivo"

				return self.datastore.update(
					self.path, id: book["id"]! as! String, document: bookToAdd)
			}

			.then { updatedBook -> Promise<Response> in
				self.assertBook(bookToAdd, book: updatedBook)
				let id = updatedBook["id"]! as! String

				return self.datastore.remove(self.path, id: id)
			}

			.then { response -> () in
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
			.path(path)
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
			.path(path)
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
			.path(path)
			.path("/\(id)")
			.get()
		.done { value, error in
			XCTAssertTrue(NSThread.isMainThread())
			expectation.fulfill()
		}

		wait()
	}

	func testRemove() {
		let expectation = expect("remove")

		guard let book = books.first else {
			return
		}

		let id = book["id"] as! String

		datastore
			.remove(path, id: id)
			.then { response -> () in
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

		datastore
			.update(path, id: id, document: book)
			.then { updatedBook -> () in
				self.assertBook(book, book: updatedBook)
				expectation.fulfill()
			}
		.done()

		wait()
	}

}