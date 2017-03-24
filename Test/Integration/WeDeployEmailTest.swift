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

@testable import WeDeploy
import RxSwift
import XCTest

class WeDeployEmailTest: BaseTest {

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

	func testSendEmail() {
		let expect = expectation(description: "correct user")

		executeAuthenticated { auth in
			WeDeploy
				.email(self.emailModuleUrl, authorization: auth)
				.from(self.username)
				.to("gagranta@gmail.com")
				.subject("subject")
				.message("body")
				.bcc("gagranta@gmail.com")
				.cc("gagranta@gmail.com")
				.replyTo("gagranta@gmail.com")
				.send()
				.valueOrFail { _ in
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testGetEmailStatus() {
		let expect = expectation(description: "correct user")

		executeAuthenticated { auth in
			WeDeploy.email(self.emailModuleUrl)
				.authorize(auth: auth)
				.checkEmailStatus(id: "202605176596079530")
				.valueOrFail { _ in
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func givenSomeEmailParams() -> (from: String, to: String, subject: String,
			message: String, cc: String, bcc: String, replyTo: String, priority: Int) {

		return ("from@from.com", "to@to.com", "subject", "message", "cc@cc.com", "bcc@cc.com", "replyto@replyTo.com", 1)
	}

	func contains(params: [(name: String, value: String)], name: String, value: String) -> Bool {
		if let param = params.filter ({ $0.name == name }).first {
			return param.value == value
		}

		return false
	}
}
