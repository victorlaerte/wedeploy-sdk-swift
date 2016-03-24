import XCTest

extension XCTestCase {

	func assertJSON(expected: String, _ result: [String: AnyObject]) {
		let dic1 = try! NSJSONSerialization.JSONObjectWithData(
			expected.dataUsingEncoding(NSUTF8StringEncoding)!,
			options: .AllowFragments) as! [String: AnyObject]

		let dic2 = NSDictionary(dictionary: result) as [NSObject : AnyObject]

		XCTAssertTrue(NSDictionary(dictionary: dic1).isEqualToDictionary(dic2))
	}

	func expect(description: String!) -> XCTestExpectation {
		return expectationWithDescription(description)
	}

	func fail(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func wait(timeout: Double? = 2, assert: (() -> ())? = nil) {
		waitForExpectationsWithTimeout(timeout!) { error in
			self.fail(error)
			assert?()
		}
	}

}