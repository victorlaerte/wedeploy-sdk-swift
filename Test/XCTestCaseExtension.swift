import XCTest

extension XCTestCase {

	func expect(description: String!) -> XCTestExpectation {
		return expectationWithDescription(description)
	}

	func fail(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func toJSONString(json: String) -> String {
		let obj = try! NSJSONSerialization.JSONObjectWithData(
			json.dataUsingEncoding(NSUTF8StringEncoding)!,
			options: .AllowFragments)

		let data = try! NSJSONSerialization.dataWithJSONObject(
			obj, options: NSJSONWritingOptions())

		return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
	}

	func wait(timeout: Double? = 2, assert: (() -> ())? = nil) {
		waitForExpectationsWithTimeout(timeout!) { error in
			self.fail(error)
			assert?()
		}
	}

}