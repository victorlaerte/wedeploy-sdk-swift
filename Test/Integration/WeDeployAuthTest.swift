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
