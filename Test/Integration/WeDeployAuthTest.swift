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
import XCTest
import RxSwift
import Foundation

class WeDeployAuthTest: BaseTest {

	var bag = DisposeBag()

	func testSignInWithPromise() {
		let expect = expectation(description: "correct login")

		WeDeploy.auth(authModuleUrl)
			.signInWith(username: username, password: password)
			.valueOrFail { _ in
				expect.fulfill()
			}

		waitForExpectations(timeout: 5, handler: nil)
	}

	func testSignInWithObservable() {
		let expect = expectation(description: "correct login")

		WeDeploy.auth(authModuleUrl)
			.signInWith(username: username, password: password)
			.toObservable()
			.subscribe(onNext: { _ in
				expect.fulfill()
			},
			onError: { error in
				XCTFail("Failed with error \(error)")
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
			.toCallback { auth, error in
				XCTAssertNotNil(auth)
				XCTAssertNil(error)
				expect.fulfill()
			}

		waitForExpectations(timeout: 5, handler: nil)
	}

	func testCurrentUser() {
		let expect = expectation(description: "correct user")

		executeAuthenticated { auth in
			WeDeploy.auth(self.authModuleUrl, authorization: auth)
				.getCurrentUser()
				.valueOrFail { user in
					XCTAssertEqual(user.email, self.username)
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 5, handler: nil)
	}

	func testGetUser() {
		let expect = expectation(description: "correct user")

		executeAuthenticated { auth in
			WeDeploy.auth(self.authModuleUrl)
				.authorize(auth: auth)
				.getUser(id: self.userId)
				.valueOrFail { user in
					XCTAssertEqual(user.email, self.username)
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testUpdateUser() {
		let expect = expectation(description: "")

		executeAuthenticated { auth in

			//Get current user
			WeDeploy.auth(self.authModuleUrl, authorization: auth)
				.getCurrentUser()
				.then { currentUser in

					// Update user
					WeDeploy.auth(self.authModuleUrl)
						.authorize(auth: auth)
						.updateUser(id: currentUser.id, name: "new", photoUrl: "http://somephoto.com")
				}
				.then { _ in
					// Get current user again
					WeDeploy.auth(self.authModuleUrl)
						.authorize(auth: auth)
						.getCurrentUser()
				}
				.valueOrFail { user in
					XCTAssertEqual(user.name, "new")
					XCTAssertEqual(user.photoUrl, "http://somephoto.com")
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testSendRecoverPasswordEmail() {
		let expect = expectation(description: "")

		WeDeploy.auth(authModuleUrl)
				.sendPasswordReset(email: username)
				.valueOrFail { _ in
					expect.fulfill()
				}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testSignOut() {
		let expect = expectation(description: "")

		executeAuthenticated { auth in
			WeDeploy.auth(self.authModuleUrl, authorization: auth)
				.signOut()
				.valueOrFail { _ in
					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}
}
