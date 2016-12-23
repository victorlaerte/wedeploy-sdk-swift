import XCTest

extension XCTestCase {

	func assertJSON(_ expected: String, _ result: [String: AnyObject]) {
		let dic1 = try! JSONSerialization.jsonObject(with:
			expected.data(using: .utf8)!,
			options: .allowFragments) as! [String: AnyObject]

		let dic2 = NSDictionary(dictionary: result) as [NSObject : AnyObject]

		XCTAssertTrue(NSDictionary(dictionary: dic1).isEqual(to: dic2))
	}

	func expect(description: String!) -> XCTestExpectation {
		return expectation(description: description)
	}

	func fail(error: Error?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func wait(timeout: Double? = 2, assert: (() -> ())? = nil) {
		waitForExpectations(timeout: timeout!) { error in
			self.fail(error: error )
			assert?()
		}
	}

}
