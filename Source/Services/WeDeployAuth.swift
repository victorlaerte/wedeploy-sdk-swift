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

#if os(macOS)
	import AppKit
#else
	import UIKit
#endif

import Foundation
import PromiseKit
import RxSwift

public class WeDeployAuth: WeDeployService {

	public static var urlRedirect = PublishSubject<URL>()
	public static var tokenSubscription: Disposable?

	public func signInWith(username: String, password: String) -> Promise<Auth> {
		return RequestBuilder.url(self.url).path("/oauth/token")
			.param(name: "grant_type", value: "password")
			.param(name: "username", value: username)
			.param(name: "password", value: password)
			.get()
			.then { response -> Auth in
				let body = try response.validate()
				let token = body["access_token"] as! String
				let auth = TokenAuth(token: token)

				return auth
			}
	}

	public func getCurrentUser() -> Promise<User> {
		return RequestBuilder
			.url(self.url)
			.path("/user")
			.authorize(auth: self.authorization)
			.get()
			.then { (response: Response) -> User in
				let body = try response.validate()

				return User(json: body)
			}
	}

	public func handle(url: URL) {
		WeDeployAuth.urlRedirect.on(.next(url))
	}

	public func signInWithRedirect(provider: AuthProvider, onSignIn: @escaping (Auth?, Error?) -> Void) {
		let authUrl = self.url
		WeDeployAuth.tokenSubscription?.dispose()

		WeDeployAuth.tokenSubscription = WeDeployAuth.urlRedirect
			.subscribe(onNext: { url in
					let token = url.absoluteString.components(separatedBy: "access_token=")[1]
					let auth = TokenAuth(token: token)

					onSignIn(auth, nil)
				})

		var url = URLComponents(string: "\(authUrl)/oauth/authorize")!
		url.queryItems = provider.providerParams

		open(url.url!)
	}

	public func createUser(email: String, password: String, name: String?) -> Promise<User> {
		var body = [
					"email": email,
					"password": password
				]

		if let name = name {
			body["name"] = name
		}

		return RequestBuilder
				.url(self.url)
				.path("/users")
				.post(body: body as AnyObject?)
				.then { response -> User in
					let body = try response.validate()
					return User(json: body)
				}
	}

	public func updateUser(id: String, email: String? = nil, password: String? = nil,
			name: String? = nil, photoUrl: String? = nil, attrs: [String : Any] = [:] ) -> Promise<Void> {

		var body = [String: Any]()

		if let email = email {
			body["email"] = email
		}

		if let password = password {
			body["password"] = password
		}

		if let name = name {
			body["name"] = name
		}

		if let photoUrl = photoUrl {
			body["photoUrl"] = photoUrl
		}

		for (key, element) in attrs {
			body[key] = element
		}

		return RequestBuilder
			.url(self.url)
			.path("/users")
			.path("/\(id)")
			.authorize(auth: authorization)
			.patch(body: body)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	public func deleteUser(id: String) -> Promise<Void> {
		return RequestBuilder
			.url(self.url)
			.path("/users")
			.path("/\(id)")
			.authorize(auth: authorization)
			.delete()
			.then { response  in
				try response.validateEmptyBody()
			}
	}

	public func getUser(id: String) -> Promise<User> {
		return RequestBuilder
				.url(self.url)
				.path("/users")
				.path("/\(id)")
				.authorize(auth: authorization)
				.get()
				.then { response -> User in
					let body = try response.validate()
					return User(json: body)
				}
	}

	public func sendPasswordReset(email: String) -> Promise<Void> {
		return RequestBuilder
				.url(self.url)
				.path("/user/recover")
				.form(name: "email", value: email)
				.post()
				.then { response in
				 	try response.validateEmptyBody()
				}
	}

	public func signOut() -> Promise<Void> {
		precondition(self.authorization != nil && self.authorization is TokenAuth,
				"you have to have an authentication to sign out")

		let token = (self.authorization as! TokenAuth).token
		return RequestBuilder
				.url(self.url)
				.path("/oauth/revoke")
				.param(name: "token", value: token)
				.get()
				.then { response -> Void in
					return try response.validateEmptyBody()
				}
	}

	#if os(macOS)

	func open(_ url: URL) {
		NSWorkspace.shared().open(url)
	}

	#else

	func open(_ url: URL) {
		if #available(iOS 10.0, tvOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		else {
			UIApplication.shared.openURL(url)
		}
	}

	#endif
}
