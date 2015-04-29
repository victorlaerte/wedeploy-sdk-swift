import XCTest

class CatchTest : XCTestCase {

	func testBlock_Returns_Error() {
		let expectation = expectationWithDescription("testCatch")
		var e: NSError?

		var p = Promise {
			return "one"
		}

		p.then(error: { (value) -> (String?, NSError?) in
			return (value, NSError(domain: "domain", code: 1, userInfo: nil))
		})

		p.done(block: { (value, error) in
			e = error
			XCTAssertNil(value)
			expectation.fulfill()
		})

		wait {
			XCTAssertEqual("domain", e!.domain)
			XCTAssertEqual(1, e!.code)
		}
	}

	func testPromise_Returns_Error() {
		let expectation = expectationWithDescription("testCatch")
		var e: NSError?

		Promise<()>(promise: { (fulfill, reject) in
			let queue = dispatch_get_global_queue(
				DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

			dispatch_async(queue, {
				reject(NSError(domain: "domain", code: 1, userInfo: nil))
			})
		})
		.done { (value, error) in
			e = error
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual("domain", e!.domain)
			XCTAssertEqual(1, e!.code)
		}
	}

	func testError_Fall_Through() {
		let expectation = expectationWithDescription("testCatch_With_Then")
		var e: NSError?

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
		.done { (value, error) in
			e = error
			expectation.fulfill()
		}

		wait(1.5) {
			XCTAssertEqual("domain", e!.domain)
			XCTAssertEqual(1, e!.code)
		}
	}

}