import XCTest

class BaseTest : XCTestCase {

	var books = [[String: AnyObject]]()
	var pad: Launchpad?
	let path = "/books"
	let server = "http://localhost:8080"
	var timeout = 1 as Double
	let title = "Cien años de soledad"

	override func setUp() {
		pad = Launchpad(server: server)
		let expectation = expectationWithDescription("setUp")
		let document = ["title": title]

		pad!.add(path, document: document) { book in
			self.books.append(book)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(timeout) { error in
			self.hasError(error)
		}
	}

	override func tearDown() {
		for book in books {
			let expectation = expectationWithDescription("tearDown")
			let id = book["id"] as String

			pad!.remove(self.path, id: id) { status in
				expectation.fulfill()
			}

			waitForExpectationsWithTimeout(timeout) { error in
				self.hasError(error)
			}
		}
	}

	func assertBook(title: String, book: [String: AnyObject]) {
		XCTAssertEqual(title, book["document"]!["title"]!! as String)
	}

	func hasError(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

}
