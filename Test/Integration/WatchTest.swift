import Foundation
import Launchpad
import XCTest

class WatchTest : BaseTest {

	func testWatch() {
		launchpad.watch().on("connected", callback: { data, ack in
			print("socket connected")
		})
	}

}