import XCTest

class WaitOperationTest : XCTestCase {

	func testFulfill() {
		let expectation = expectationWithDescription("testFulfill")
		let queue = NSOperationQueue()

		let operation = WaitOperation({ (fulfill, reject) in
			fulfill("one")
			expectation.fulfill()
		})

		queue.addOperation(operation)

		wait {
			XCTAssertEqual("one", operation.output as! String)
		}
	}

	func testReject() {
		let expectation = expectationWithDescription("testReject")
		let queue = NSOperationQueue()
		var error: NSError?

		let operation = WaitOperation({ (fulfill, reject) in
			reject(NSError(domain: "domain", code: 1, userInfo: nil))
		}, catch: {
			error = $0
			expectation.fulfill()
		})

		queue.addOperation(operation)

		wait {
			XCTAssertEqual("domain", error!.domain)
			XCTAssertEqual(1, error!.code)
		}
	}

}