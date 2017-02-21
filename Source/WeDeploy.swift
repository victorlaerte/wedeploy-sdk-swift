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


public class WeDeploy : RequestBuilder {

	public static var authSession: AuthSession?

	static var dataUrl: String?
	static var emailUrl: String?

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
		let url = validate(url: url)

		if let authSession = authSession, authSession.url == url {
			return auth()
		}

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

	public class func data(_ url: String) -> WeDeployData {
		dataUrl = validate(url: url)

		return WeDeployData(dataUrl!, authorization: authSession?.currentAuth)
	}

	public class func data() -> WeDeployData {
		precondition(dataUrl != nil, "you have to initialize data module")

		return WeDeployData(dataUrl!, authorization: authSession?.currentAuth)
	}

	public class func email(_ url: String) -> WeDeployEmail {
		emailUrl = validate(url: url)

		return WeDeployEmail(emailUrl!, authorization: authSession?.currentAuth)
	}

	public class func email() -> WeDeployEmail {
		precondition(emailUrl != nil, "you have to initialize data module")

		return WeDeployEmail(emailUrl!, authorization: authSession?.currentAuth)
	}

	class func validate(url: String) -> String {
		var finalUrl = url
		if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
			finalUrl = "http://" + finalUrl
		}

		if url.hasSuffix("/") {
			let slashIndex = finalUrl.index(finalUrl.endIndex, offsetBy: -1)
			finalUrl = finalUrl.substring(to: slashIndex)
		}

		return finalUrl
	}
}
