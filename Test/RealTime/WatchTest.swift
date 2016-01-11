@testable import Launchpad
import XCTest

class WatchTest : BaseTest {

	func testParseURL() {
		let urlWithoutQuery = RealTime.parseURL("http://domain:8080/path/a")
		XCTAssertEqual("domain:8080/path/a/?url=path%2Fa", urlWithoutQuery)
	}

	func testWatch() {
		let expectation = expect("watch")
		let socket = launchpad.watch(["log": true])

		socket.on("connect") { data in
			expectation.fulfill()
		}

		wait()
	}

}