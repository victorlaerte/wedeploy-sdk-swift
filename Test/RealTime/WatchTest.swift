import Launchpad
import XCTest

class WatchTest : BaseTest {

	func testWatch() {
		let expectation = expect("watch")
		let socket = launchpad.watch(["log": true])

		socket.on("connect") { data in
			expectation.fulfill()
		}

		wait()
	}

}