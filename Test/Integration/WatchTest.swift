import Launchpad
import Socket_IO_Client_Swift
import XCTest

class WatchTest : BaseTest {

	func testWatch() {
		let expectation = expect("watch")
		let socket = launchpad.watch()

		socket.on("connect", callback: { data, ack in
			expectation.fulfill()
		})

		wait()
	}

}