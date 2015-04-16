import XCTest

class RestTest : XCTestCase {

	var books: [[String: AnyObject]] = []
	var pad: Launchpad?
	let path = "/books"
	let server = "http://localhost:8080"
	var timeout = 1 as Double
	let title = "Cien años de soledad"

	override func setUp() {
		self.pad = Launchpad(server: self.server)
		let expectation = expectationWithDescription("setUp")
		let document = ["title": self.title]

		self.pad!.add(self.path, document: document) { book in
			self.books.append(book)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	override func tearDown() {
		for book in self.books {
			let expectation = expectationWithDescription("tearDown")
			let id = book["id"] as String

			self.pad!.remove(self.path, id: id) { status in
				expectation.fulfill()
			}

			waitForExpectationsWithTimeout(timeout) { error in
				self.hasError(error)
			}
		}
	}

	func testAdd() {
		let expectation = expectationWithDescription("add")
		let document = ["title": self.title]

		self.pad!.add(self.path, document: document) { book in
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
		let id = self.books[0]["id"] as String

		self.pad!.get(self.path, id: id) { book in
			self.assertBook(self.title, book: book)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testUpdate() {
		let expectation = expectationWithDescription("update")

		let book = self.books[0]
		var document = book["document"] as [String: String]
		document["title"] = "La fiesta del chivo"

		let id = book["id"] as String

		self.pad!.update(self.path, id: id, document: document) { updatedBook in
			self.assertBook(document["title"]!, book: updatedBook)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testList() {
		let expectation = expectationWithDescription("list")

		self.pad!.list(self.path) { books in
			XCTAssertEqual(1, books.count)
			self.assertBook(self.title, book: books[0])
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	func testRemove() {
		let expectation = expectationWithDescription("remove")
		let id = self.books[0]["id"] as String

		self.pad!.remove(self.path, id: id) { status in
			XCTAssertEqual(204, status)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	private func assertBook(title: String, book: [String: AnyObject]) {
		XCTAssertEqual(title, book["document"]!["title"]!! as String)
	}

	private func hasError(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

}