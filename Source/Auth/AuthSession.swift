//
//  File.swift
//  WeDeploy
//
//  Created by Victor Galán on 30/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation

public struct AuthSession {
	public var currentUser: User?
	public var currentAuth: Auth?

	let url: String

	init(_ url: String) {
		self.url = url
	}

}

