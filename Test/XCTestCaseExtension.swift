import XCTest

extension XCTestCase {

	func assertJSON(expected: String, _ result: [String: AnyObject]) {
		let dic1 = toJSONObject(expected)
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

	func toJSONObject(json: String) -> [String: AnyObject] {
		return try! NSJSONSerialization.JSONObjectWithData(
			json.dataUsingEncoding(NSUTF8StringEncoding)!,
			options: .AllowFragments) as! [String: AnyObject]
	}

	func wait(timeout: Double? = 2, assert: (() -> ())? = nil) {
		waitForExpectationsWithTimeout(timeout!) { error in
			self.fail(error)
			assert?()
		}
	}
}