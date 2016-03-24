@testable import Launchpad
import Socket_IO_Client_Swift
import XCTest

class WatchTest : BaseTest {

	func testParseURL() {
		let url = SocketIOClientFactory.parseURL("http://domain:8080/path/a")
		XCTAssertEqual("domain:8080", url.host)
		XCTAssertEqual("/path/a", url.path)
	}

	func testParseURL_With_Query() {
		let params = [
			NSURLQueryItem(name: "param1", value: "value1"),
			NSURLQueryItem(name: "param2", value: "value2")
		]

		let url = SocketIOClientFactory.parseURL(
			"http://domain:8080/path/a", params: params)

		XCTAssertEqual("domain:8080", url.host)
		XCTAssertEqual("/path/a", url.path)
		XCTAssertEqual("/path/a?param1=value1&param2=value2", url.query)
	}

	func testWatch() {
		let expectation = expect("watch")
		let socket = launchpad.watch()

		guard let book = booksToAdd.first else {
			return
		}

		socket.on("connect", callback: { _ in
			self.launchpad
				.post(book)
			.done()
		})

		socket.on("changes", callback: { data, _ in
			guard let books = data[0] as? [[String: AnyObject]] else {
				XCTFail("Could not parse books")
				expectation.fulfill()
				return
			}

			XCTAssertEqual(books.count, 3)
			expectation.fulfill()
		})

		wait(5)
	}

	func testWatch_With_Query() {
		let expectation = expect("watch")

		guard var book = books.first else {
			return
		}

		book["title"] = "La fiesta del chivo"

		let id = book["id"] as! String

		let socket = launchpad
			.filter("year", book["year"]!)
			.watch()

		socket.on("connect", callback: { _ in
			self.launchpad
				.path("/\(id)")
				.put(book)
			.done()
		})

		socket.on("changes", callback: { data, _ in
			guard let books = data[0] as? [[String: AnyObject]] else {
				XCTFail("Could not parse books")
				expectation.fulfill()
				return
			}

			XCTAssertEqual(books.count, 1)
			self.assertBook(book, book: books[0])
			expectation.fulfill()
		})

		wait(5)
	}

}