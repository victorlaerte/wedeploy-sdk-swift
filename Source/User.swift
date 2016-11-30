//
//  User.swift
//  wedeployPoC
//
//  Created by Victor Galán on 22/11/16.
//  Copyright © 2016 liferay. All rights reserved.
//

import Foundation

public struct User {
	public let email: String
	public let name: String?
	public let id: String

	public init(json: [String :AnyObject]) {

		email = json["email"] as! String
		name = json["name"] as? String
		id = json["id"] as! String
	}

	public init(email: String, name: String) {
		self.email = email
		self.name = name
		self.id = ""
	}
}
