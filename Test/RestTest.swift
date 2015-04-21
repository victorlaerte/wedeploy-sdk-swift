import XCTest

class RestTest : BaseTest {

	func testAdd() {
		let expectation = expectationWithDescription("add")
		let bookToAdd = booksToAdd.first!

		pad.add(path, document: bookToAdd) { book in
			self.assertBook(bookToAdd, result: book)
			self.books.append(book)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testGet() {
		let expectation = expectationWithDescription("get")
		let id = books.first!["id"] as String

		pad.get(path, id: id) { book in
			self.assertBook(self.booksToAdd.first!, result: book)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testList() {
		let expectation = expectationWithDescription("list")

		pad.list(path) { books in
			XCTAssertEqual(self.booksToAdd.count, books.count)
			self.assertBook(self.booksToAdd.first!, result: books.first!)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testRemove() {
		let expectation = expectationWithDescription("remove")
		let id = books.first!["id"] as String

		pad.remove(path, id: id) { status in
			XCTAssertEqual(204, status)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testUpdate() {
		let expectation = expectationWithDescription("update")

		let book = books.first!
		var document = book["document"] as [String: String]
		document["title"] = "La fiesta del chivo"

		let id = book["id"] as String

		pad.update(path, id: id, document: document) { updatedBook in
			self.assertBook(document, result: updatedBook)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

}