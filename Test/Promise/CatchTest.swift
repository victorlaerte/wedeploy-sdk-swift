import XCTest

class CatchTest : XCTestCase {

	func testAsyncCatch() {
		let expectation = expectationWithDescription("testAsyncCatch")
		var output: NSError?

		let queue = dispatch_get_global_queue(
			DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

		Promise<String>({ (resolve, reject) in
			dispatch_async(queue, {
				let error = NSError(domain: "domain", code: 1, userInfo: nil)
				reject(error)
			})
		})
		.catch({ error in
			output = error
			expectation.fulfill()
		})
		.done()

		wait {
			XCTAssertEqual("domain", output!.domain)
			XCTAssertEqual(1, output!.code)
		}
	}

} 