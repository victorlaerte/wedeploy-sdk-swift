/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/

import XCTest

extension XCTestCase {

	func assertJSON(_ expected: String, _ result: [String: Any]) {
		let dic1 = try! JSONSerialization.jsonObject(with:
			expected.data(using: .utf8)!,
			options: .allowFragments) as! [String: Any]

		let dic2 = NSDictionary(dictionary: result)

		XCTAssertEqual(NSDictionary(dictionary: dic1), dic2)
	}

	func expect(description: String!) -> XCTestExpectation {
		return expectation(description: description)
	}

	func fail(error: Error?) {
		if error == nil {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func wait(timeout: Double? = 2, assert: (() -> Void)? = nil) {
		waitForExpectations(timeout: timeout!) { error in
			self.fail(error: error )
			assert?()
		}
	}

}
