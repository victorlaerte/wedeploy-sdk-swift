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
import PromiseKit
import RxSwift
import Foundation


class WeDeployAuthTest : BaseTest {

	var bag = DisposeBag()


	func testSignInWithPromise() {
		let expect = expectation(description: "correct login")

		WeDeploy.auth(authModuleUrl)
				.signInWith(username: username, password: password)
				.tap { result in
					if case let .fulfilled(user) = result {
						XCTAssertEqual(user.email, self.username)
						expect.fulfill()
					}
					else {
						XCTFail()
					}
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
				.tap { result in
					if case let .fulfilled(user) = result {
						XCTAssertEqual(user.email, self.username)
						expect.fulfill()
					}
					else {
						XCTFail()
					}
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testUpdateUser() {
		let expect = expectation(description: "")

		executeAuthenticated {
			let currentUserId = WeDeploy.auth().currentUser!.id

			WeDeploy.auth()
				.updateUser(id: currentUserId, name: "new", photoUrl: "http://somephoto.com")
				.toObservable()
				.flatMap {
					WeDeploy.auth()
						.getCurrentUser()
						.toObservable()
				}
				.subscribe(onNext: { (user) in
					XCTAssertEqual(user.name , "new")
					XCTAssertEqual(user.photoUrl, "http://somephoto.com")
					expect.fulfill()
				}, onError: { _ in XCTFail()})
				.disposed(by: self.bag)
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func  testDeleteUser() {
		let expect = expectation(description: "")

		executeAuthenticated {
			WeDeploy.auth()
				.createUser(email: "new2@new.com", password: "new", name: "new")
				.toObservable()
				.flatMap { user in
					WeDeploy.auth()
						.signInWith(username: "new2@new.com", password: "new")
						.toObservable()
				}
				.flatMap { user in
					WeDeploy.auth()
						.deleteUser(id: user.id)
						.toObservable()
				}
				.subscribe(onNext: { _ in
					expect.fulfill()
				}, onError: { error in print(error); XCTFail()})
				.disposed(by: self.bag)
		}

		waitForExpectations(timeout: 20, handler: nil)

	}

	func testSendRecoverPasswordEmail() {
		let expect = expectation(description: "")

		WeDeploy.auth(authModuleUrl)
				.sendPasswordReset(email: username)
				.tap { result in
					if case .fulfilled(_) = result {
						expect.fulfill()
					}
					else {
						XCTFail()
					}
				}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testSignOut() {
		let expect = expectation(description: "")

		executeAuthenticated {
			WeDeploy.auth()
				.signOut()
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
