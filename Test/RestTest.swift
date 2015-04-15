import XCTest

class RestTest : XCTestCase {

	override func setUp() {
	}

	override func tearDown() {
	}

	func testGet() {
		let expectation = expectationWithDescription("get")
		let pad = Launchpad(server: "http://localhost:8080")

		pad.get("/books/85024121006487456") { book in
			XCTAssertEqual(
				"Neuromancer", book["document"]!["title"]!! as String)

			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(1) { (error) in
			if (error != nil) {
				XCTFail(error.localizedDescription)
			}
		}
	}

	func testList() {
		let expectation = expectationWithDescription("list")
		let pad = Launchpad(server: "http://localhost:8080")

		pad.list("/books") { books in
			for book in books {
				println(book["document"]!["title"]!!)
			}

			XCTAssertEqual(2, books.count)

			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(1) { (error) in
			if (error != nil) {
				XCTFail(error.localizedDescription)
			}
		}
	}

}