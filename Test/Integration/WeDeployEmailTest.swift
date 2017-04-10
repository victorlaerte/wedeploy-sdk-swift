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

	func testSendEmail() {
		let auth = givenAnAuth()
		let emailService = WeDeploy.email(self.emailModuleUrl, authorization: auth)
			.from(self.username)
			.to(self.username)
			.message("some message")

		let (emailId, error) = emailService.send().sync()

		XCTAssertNotNil(emailId)
		XCTAssertNil(error)
	}

	func testGetEmailStatus() {
		let auth = givenAnAuth()
		let emailServide = WeDeploy.email(self.emailModuleUrl, authorization: auth)

		let (emailStatus, error) = emailServide.checkEmailStatus(id: "202605176596079530").sync()

		XCTAssertNotNil(emailStatus)
		XCTAssertNil(error)
	}
}
