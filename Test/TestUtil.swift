import Foundation
import XCTest

let timeout = 1 as Double

extension XCTestCase {
	func fail(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func wait(assert: (() -> ())? = nil) {
		waitForExpectationsWithTimeout(timeout) { error in
			self.fail(error)
			assert?()
		}
	}
}