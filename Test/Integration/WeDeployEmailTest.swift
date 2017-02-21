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

	func testGetUser() {
		let expect = expectation(description: "correct user")

		executeAuthenticated {
			WeDeploy
				.email(self.emailModuleUrl)
				.sendEmail(from: self.username, to: self.username, subject: "subject", body: "body")
				.tap { result in
					if case .fulfilled(_) = result {
						expect.fulfill()
					}
					else {
						XCTFail()
					}
			}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}
}
