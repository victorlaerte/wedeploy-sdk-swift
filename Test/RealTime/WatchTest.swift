@testable import Launchpad
import Socket_IO_Client_Swift
import XCTest

class WatchTest : BaseTest {

	func testParseURL() {
		let url = SocketIOClientFactory.parseURL("http://domain:8080/path/a")
		XCTAssertEqual("domain:8080", url.host)
		XCTAssertEqual("/path/a", url.path)
	}

	func testWatch() {
		let expectation = expect("watch")
		let socket = launchpad.watch()

		socket.on("connect", callback: { _ in
			self.launchpad
				.post(self.booksToAdd.first!)
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

		wait(2)
	}

}