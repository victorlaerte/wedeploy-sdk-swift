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

import WeDeploy
import XCTest
import PromiseKit

class BaseTest: XCTestCase {

	var username: String!
	var password: String!
	var userId: String!

	var authModuleUrl: String!
	var emailModuleUrl: String!
	var dataModuleUrl: String!

	override func setUp() {
		loadSettings()
	}

	private func loadSettings() {
		let bundle = Bundle(for: type(of: self))
		let file = bundle.path(forResource: "settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: file!) as! [String: String]

		username = settings["username"]
		password = settings["password"]
		userId = settings["userId"]

		authModuleUrl = settings["authModuleUrl"]
		emailModuleUrl = settings["emailModuleUrl"]
		dataModuleUrl = settings["dataModuleUrl"]
	}

	func executeAuthenticated(block: @escaping (Auth) -> Void) {
		WeDeploy.auth(authModuleUrl)
			.signInWith(username: username, password: password)
			.tap { auth in
				if case let .fulfilled(auth) = auth {
					block(auth)
				}
		}
	}
}

extension Promise {

	func valueOrFail(_ action: @escaping (T) -> Void) {
		self.tap { result in
			switch result {
				case .fulfilled(let value):
					action(value)
				case .rejected(let error):
					XCTFail("Rejected promise with error \(error)")
			}
		}
	}
}
