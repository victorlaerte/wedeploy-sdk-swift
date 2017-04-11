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

public struct User {
	public let email: String?
	public let name: String?
	public let id: String
	public let photoUrl: String?
	public let attrs: [String : Any]

	public init(json: [String :AnyObject]) {
		email = json["email"] as? String
		name = json["name"] as? String
		id = json["id"] as! String
		photoUrl = json["photoUrl"] as? String
		attrs = json
	}

	public init(email: String, name: String, photoUrl: String? = nil, attrs: [String : Any] = [:]) {
		self.email = email
		self.name = name
		self.id = ""
		self.photoUrl = photoUrl
		self.attrs = attrs
	}
}
