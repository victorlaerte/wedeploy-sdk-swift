import XCTest

class CatchTest : XCTestCase {

	func testCatch() {
		let expectation = expectationWithDescription("testCatch")
		var error: NSError?

		Promise<()>(promise: { (fulfill, reject) in
			let queue = dispatch_get_global_queue(
				DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

			dispatch_async(queue, {
				reject(NSError(domain: "domain", code: 1, userInfo: nil))
			})
		})
		.catch {
			error = $0
			expectation.fulfill()
		}
		.done()

		wait {
			XCTAssertEqual("domain", error!.domain)
			XCTAssertEqual(1, error!.code)
		}
	}

	func testCatch_With_Then() {
		let expectation = expectationWithDescription("testCatch_With_Then")
		var error: NSError?

		Promise<()>(promise: { (fulfill, reject) in
			let queue = dispatch_get_global_queue(
				DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

			dispatch_async(queue, {
				sleep(1)
				reject(NSError(domain: "domain", code: 1, userInfo: nil))
			})
		})
		.then {
			XCTFail(
				"Then shouldn't be called, should be skipped directly to catch")
		}
		.catch {
			error = $0
			expectation.fulfill()
		}
		.done()

		wait(1.5) {
			XCTAssertEqual("domain", error!.domain)
			XCTAssertEqual(1, error!.code)
		}
	}

}