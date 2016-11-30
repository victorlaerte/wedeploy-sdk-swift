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

	public class func email(_ url: String) -> WeDeployEmail {
		return WeDeployEmail(url)
				.authorize(auth: authSession?.currentAuth)
	}
}
