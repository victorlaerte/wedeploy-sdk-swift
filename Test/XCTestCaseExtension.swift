/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* 3. Neither the name of Liferay, Inc. nor the names of its contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import XCTest

extension XCTestCase {

	func assertJSON(_ expected: String, _ result: [String: Any],
		file: StaticString = #file, line: UInt = #line, function: String = #function) {

		let dic1 = try! JSONSerialization.jsonObject(with:
			expected.data(using: .utf8)!,
			options: .allowFragments) as! [String: Any]

		let dic2 = NSDictionary(dictionary: result)

		XCTAssertEqual(NSDictionary(dictionary: dic1), dic2, file: file, line: line)
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

	func matchSnapshot(_ result: [String: Any],
		file: StaticString = #file, line: UInt = #line, function: String = #function) {

		let start = function.range(of: "test")!.upperBound
		let end = function.range(of: "()")!.lowerBound

		let snapshotFileName = String(function[start..<end]).lowercased()

		let fileUrl = Bundle.init(for: type(of: self)).url(forResource: snapshotFileName, withExtension: "json")

		let content = try! Data(contentsOf: fileUrl!)

		let expected = try! JSONSerialization.jsonObject(with:
			content, options: .allowFragments) as! [String: Any]

		XCTAssertEqual(NSDictionary(dictionary: expected), NSDictionary(dictionary: result), file: file, line: line)
	}

}
