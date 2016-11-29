//
//  WeDeploy.swift
//  Launchpad
//
//  Created by Victor Galán on 29/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation

struct AuthSession {
	internal var currentUser: User?
	internal var currentAuth: Auth?

	let url: String

	init(_ url: String) {
		self.url = url
	}

}


public class WeDeploy : RequestBuilder {

	internal static var authSession: AuthSession?

	override var authorization: Auth? {
		set {
			self.authorization = newValue
		}
		get {
			return WeDeploy.authSession?.currentAuth
		}
	}

	override public class func url(_ url: String) -> WeDeploy {
		return WeDeploy(url)
	}

	public class func auth(_ url: String) -> WeDeployAuth {
		authSession = AuthSession(url)

		return WeDeployAuth(url)
	}

	public class func auth() -> WeDeployAuth {
		precondition(authSession != nil, "you have to initialize auth module")

		return WeDeployAuth(
				authSession!.url,
				user: authSession!.currentUser,
				authorization: authSession!.currentAuth)
	}

	public func data() -> Self {
		return self
	}

	public func email() -> Self {
		return self
	}
}
