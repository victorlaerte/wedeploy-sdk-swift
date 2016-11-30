//
//  WeDeployAuthTest.swift
//  Launchpad
//
//  Created by Victor Galán on 30/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

@testable import Launchpad
import XCTest
import later
import RxSwift
import Foundation


class WeDeployAuthTest : BaseTest {

	var bag = DisposeBag()


	func testSignInWithPromise() {
		let expect = expectation(description: "correct login")

		WeDeploy.auth(authModuleUrl)
				.signInWith(username: username, password: password)
				.done { user, _ in
					XCTAssertNotNil(user)
					XCTAssertEqual(user?.email, self.username)
					expect.fulfill()
				}

		waitForExpectations(timeout: 5, handler: nil)
	}

	func testSignInWithObservable() {
		let expect = expectation(description: "correct login")

		WeDeploy.auth(authModuleUrl)
			.signInWith(username: username, password: password)
			.toObservable()
			.subscribe(onNext: { user in
				XCTAssertNotNil(user)
				XCTAssertEqual(user.email, self.username)
				expect.fulfill()
			},
			onError: { _ in
				XCTFail("this should not be called")
			})
			.addDisposableTo(bag)

		waitForExpectations(timeout: 5, handler: { _ in
			self.bag = DisposeBag()
		})
	}

	func testSignInWithCallback() {
		let expect = expectation(description: "correct login")

		WeDeploy.auth(authModuleUrl)
			.signInWith(username: username, password: password)
			.toCallback { user, _ in
				XCTAssertNotNil(user)
				XCTAssertEqual(user?.email, self.username)
				expect.fulfill()
			}

		waitForExpectations(timeout: 5, handler: nil)
	}

	func testGetUser() {
		let expect = expectation(description: "correct user")

		executeAuthenticated {
			WeDeploy.auth()
				.getUser(id: self.userId)
				.done { user, _ in
					XCTAssertNotNil(user)
					XCTAssertEqual(user?.email, self.username)
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testSendRecoverPasswordEmail() {
		let expect = expectation(description: "")

		WeDeploy.auth(authModuleUrl)
				.sendPasswordReset(email: username)
				.done { _, error in
					XCTAssertNil(error)
					expect.fulfill()
				}

		waitForExpectations(timeout: 10, handler: nil)
	}


}
