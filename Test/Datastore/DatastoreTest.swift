import XCTest

class DatastoreTest : BaseTest {

	func testAdd() {
		let expectation = expect("add")
		let bookToAdd = booksToAdd.first!

		datastore.add(path, document: bookToAdd, success: { book in
			self.assertBook(bookToAdd, result: book)
			self.books.append(book)
			expectation.fulfill()
		})

		wait()
	}

	func testGet() {
		let expectation = expect("get")
		let id = books.first!["id"] as! String

		datastore.get(path, id: id, success: { book in
			self.assertBook(self.booksToAdd.first!, result: book)
			expectation.fulfill()
		})

		wait()
	}

	func testList() {
		let expectation = expect("list")

		datastore.list(path, success: { books in
			XCTAssertEqual(self.booksToAdd.count, books.count)
			self.assertBook(self.booksToAdd.first!, result: books.first!)
			expectation.fulfill()
		})

		wait()
	}

	func testMainThread() {
		let expectation = expect("testMainThread")
		let id = books.first!["id"] as! String

		datastore.get(path, id: id, success: { book in
			XCTAssertTrue(NSThread.isMainThread())
			expectation.fulfill()
		})

		wait()
	}

	func testRemove() {
		let expectation = expect("remove")
		let id = books.first!["id"] as! String

		datastore.remove(path, id: id, success: { status in
			XCTAssertEqual(204, status)
			expectation.fulfill()
		})

		wait()
	}

	func testUpdate() {
		let expectation = expect("update")

		var book = books.first!
		book["title"] = "La fiesta del chivo"

		let id = book["id"] as! String

		datastore.update(path, id: id, document: book, success: { updatedBook in
			self.assertBook(book, result: updatedBook)
			expectation.fulfill()
		})

		wait()
	}

}