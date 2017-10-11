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

@testable import WeDeploy
import XCTest
import Foundation

class EmailServiceTest: BaseTest {

	func testEmailHasCorrectParams() {
		let params = givenSomeEmailParams()

		let emailService = WeDeploy.email("")
			.from(params.from)
			.to(params.to)
			.subject(params.subject)
			.message(params.message)
			.bcc(params.bcc)
			.cc(params.cc)
			.replyTo(params.replyTo)
			.priority(params.priority)

		XCTAssertTrue(contains(params: emailService.params, name: "from", value: params.from))
		XCTAssertTrue(contains(params: emailService.params, name: "to", value: params.to))
		XCTAssertTrue(contains(params: emailService.params, name: "subject", value: params.subject))
		XCTAssertTrue(contains(params: emailService.params, name: "message", value: params.message))
		XCTAssertTrue(contains(params: emailService.params, name: "bcc", value: params.bcc))
		XCTAssertTrue(contains(params: emailService.params, name: "cc", value: params.cc))
		XCTAssertTrue(contains(params: emailService.params, name: "replyTo", value: params.replyTo))
		XCTAssertTrue(contains(params: emailService.params, name: "priority", value: "\(params.priority)"))
	}

	func testAppendCCsIntoEmailParams() {
		let cc1 = "cc1@cc.com"
		let cc2 = "cc2@cc.com"

		let emailService = WeDeploy.email("")
			.cc(cc1)
			.cc(cc2)

		XCTAssertEqual(emailService.params.count, 2)
		XCTAssertEqual(emailService.params[0].value, cc1)
		XCTAssertEqual(emailService.params[1].value, cc2)
	}

	func testAppendBCCsIntoEmailParams() {
		let bcc1 = "bcc1@cc.com"
		let bcc2 = "bcc2@cc.com"

		let emailService = WeDeploy.email("")
			.bcc(bcc1)
			.bcc(bcc2)

		XCTAssertEqual(emailService.params.count, 2)
		XCTAssertEqual(emailService.params[0].value, bcc1)
		XCTAssertEqual(emailService.params[1].value, bcc2)
	}

	func givenSomeEmailParams() -> (from: String, to: String, subject: String,
		message: String, cc: String, bcc: String, replyTo: String, priority: Int) {

			return ("from@from.com", "to@to.com", "subject", "message", "cc@cc.com",
				"bcc@cc.com", "replyto@replyTo.com", 1)
	}

	func contains(params: [(name: String, value: String)], name: String, value: String) -> Bool {
		if let param = params.filter ({ $0.name == name }).first {
			return param.value == value
		}

		return false
	}
}
