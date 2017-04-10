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
import Foundation

class WeDeployAuthTest: BaseTest {

	func testSignIn() {
		let (auth, error) = WeDeploy.auth(authModuleUrl)
			.signInWith(username: username, password: password).sync()

		XCTAssertNotNil(auth)
		XCTAssertNil(error)
	}

	func testCurrentUser() {
		let auth = givenAnAuth()
		let authService = WeDeploy.auth(authModuleUrl, authorization: auth)

		let (user, error) = authService.getCurrentUser().sync()

		XCTAssertNotNil(user)
		XCTAssertNil(error)
		if user != nil {
			XCTAssertEqual(user!.email, username)
		}
	}

	func testGetUser() {
		let auth = givenAnAuth()
		let authService = WeDeploy.auth(authModuleUrl, authorization: auth)

		let (user, error) = authService.getUser(id: userId).sync()

		XCTAssertNotNil(user)
		XCTAssertNil(error)
		if user != nil {
			XCTAssertEqual(user!.email, username)
		}
	}

	func testUpdateUser() {
		let auth = givenAnAuth()
		let authService = WeDeploy.auth(authModuleUrl, authorization: auth)

		// Get current user
		let (user, error) = authService.getCurrentUser().sync()

		if user == nil {
			XCTFail("failed to obtain the user \(String(describing: error))")
			return
		}

		// Update current user
		let (voidResponse, errorUpdating): (Void?, Error?) = authService
				.updateUser(id: user!.id, name: "new", photoUrl: "http://somephoto.com").sync()

		if voidResponse == nil {
			XCTFail("failed to obtain the user \(String(describing: errorUpdating))")
			return
		}

		// Get current user again
		let (userUpdated, errorUser) = authService.getCurrentUser().sync()

		XCTAssertNotNil(userUpdated)
		XCTAssertNil(errorUser)
		if user != nil {
			XCTAssertEqual(userUpdated!.name, "new")
			XCTAssertEqual(userUpdated!.photoUrl, "http://somephoto.com")
		}
	}

	func testSendRecoverPasswordEmail() {
		let authService = WeDeploy.auth(authModuleUrl)

		let (voidResponse, error): (Void?, Error?) = authService.sendPasswordReset(email: username).sync()

		XCTAssertNotNil(voidResponse)
		XCTAssertNil(error)
	}

	func testSignOut() {
		let auth = givenAnAuth()
		let authService = WeDeploy.auth(authModuleUrl, authorization: auth)

		let (voidResponse, error): (Void?, Error?) = authService.signOut().sync()

		XCTAssertNotNil(voidResponse)
		XCTAssertNil(error)
	}
}
