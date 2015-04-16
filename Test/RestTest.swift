import XCTest

class RestTest : XCTestCase {

	override func setUp() {
	}

	override func tearDown() {
	}

	func testAdd() {
		let expectation = expectationWithDescription("add")
		let pad = Launchpad(server: "http://localhost:8080")

		pad.add("/books", document: ["title": "Cien anos de soledad"]) { book in
			XCTAssertEqual(
				"Cien anos de soledad", book["document"]!["title"]!! as String)

			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(1) { (error) in
			if (error != nil) {
				XCTFail(error.localizedDescription)
			}
		}
	}

	func testGet() {
		let expectation = expectationWithDescription("get")
		let pad = Launchpad(server: "http://localhost:8080")

		pad.get("/books/85216554258390563") { book in
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

			XCTAssertEqual(1, books.count)

			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(1) { (error) in
			if (error != nil) {
				XCTFail(error.localizedDescription)
			}
		}
	}

	func testRemove() {
		let expectation = expectationWithDescription("remove")
		let pad = Launchpad(server: "http://localhost:8080")

		pad.remove("/books/85216554738542310") { status in
			XCTAssertEqual(204, status)
			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(1) { (error) in
			if (error != nil) {
				XCTFail(error.localizedDescription)
			}
		}
	}

}