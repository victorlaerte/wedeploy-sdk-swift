import Foundation
import XCTest

extension XCTestCase {
	func fail(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func wait(_ timeout: Double? = 1 , assert: (() -> ())? = nil) {
		waitForExpectationsWithTimeout(timeout!) { error in
			self.fail(error)
			assert?()
		}
	}
}