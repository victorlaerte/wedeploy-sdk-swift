//
//  WeDeployEmailTest.swift
//  Launchpad
//
//  Created by Victor Galán on 30/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.

@testable import Launchpad
import later
import RxSwift
import XCTest

class WeDeployEmailTest: BaseTest {

	func testGetUser() {
		let expect = expectation(description: "correct user")

		executeAuthenticated {
			WeDeploy
				.email(self.emailModuleUrl)
				.sendEmail(from: self.username, to: self.username, subject: "subject", body: "body")
				.done { id, _ in
					XCTAssertNotNil(id)
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}
}
