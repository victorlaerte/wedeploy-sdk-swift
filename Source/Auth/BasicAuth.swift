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

public class BasicAuth : Auth {

	public var password: String
	public var username: String

	public init(_ username: String, _ password: String) {
		self.username = username
		self.password = password
	}

	public var authHeaders: [String : String] {
		var credentials = "\(username):\(password)"
		let data = credentials.data(using: .utf8)
		credentials = data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))

		return ["Authorization" : "Basic " + credentials]
	}
}
