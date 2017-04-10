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

import Foundation

class Constants: NSObject {

	private(set) static var username: String!
	private(set) static var password: String!
	private(set) static var userId: String!

	private(set) static var authModuleUrl: String!
	private(set) static var emailModuleUrl: String!
	private(set) static var dataModuleUrl: String!

	override init() {
		super.init()
		loadSettings()
	}

	private func loadSettings() {
		let bundle = Bundle(for: type(of: self))
		let file = bundle.path(forResource: "settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: file!) as! [String: String]

		Constants.username = settings["username"]
		Constants.password = settings["password"]
		Constants.userId = settings["userId"]

		Constants.authModuleUrl = settings["authModuleUrl"]
		Constants.emailModuleUrl = settings["emailModuleUrl"]
		Constants.dataModuleUrl = settings["dataModuleUrl"]
	}
}
