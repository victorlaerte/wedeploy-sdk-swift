import XCTest

class RestTest : BaseTest {

	func testAdd() {
		let expectation = expectationWithDescription("add")
		let document = ["title": title]

		pad.add(path, document: document) { book in
			self.assertBook(self.title, book: book)
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
			self.assertBook(self.title, book: book)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testList() {
		let expectation = expectationWithDescription("list")

		pad.list(path) { books in
			XCTAssertEqual(1, books.count)
			self.assertBook(self.title, book: books.first!)
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
			self.assertBook(document["title"]!, book: updatedBook)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

}