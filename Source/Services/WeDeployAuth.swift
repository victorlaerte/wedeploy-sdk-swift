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
import PromiseKit
import RxSwift

public class WeDeployAuth {

	public static var urlRedirect = PublishSubject<URL>()
	public static var tokenSubscription: Disposable?

	public var currentUser: User?

	var authorization: Auth?
	let url: String

	init(_ url: String, user: User? = nil, authorization: Auth? = nil) {
		self.url = url
		self.currentUser = user
		self.authorization = authorization
	}

	public func signInWith(username: String, password: String) -> Promise<User> {
		return RequestBuilder.url(self.url).path("/oauth/token")
			.param(name: "grant_type", value: "password")
			.param(name: "username", value: username)
			.param(name: "password", value: password)
			.get()
			.then { response -> Promise<()> in

				return Promise<()> { fulfill, reject in
					do {
						let body = try response.validate()
						let token = body["access_token"] as! String
						let auth = TokenAuth(token: token)

						self.authorization = auth
						WeDeploy.authSession?.currentAuth = auth

						fulfill(())

					} catch let error {
						reject(error)
					}

				}
			}
			.then { _ -> Promise<User> in
				return self.getCurrentUser()
			}
	}

	internal func getCurrentUser() -> Promise<User> {
		return RequestBuilder
			.url(self.url)
			.path("/user")
			.authorize(auth: self.authorization)
			.get()
			.then { (response: Response) -> User in

				let body = response.body as! [String : AnyObject]

				let user = User(json: body)

				self.currentUser = user
				WeDeploy.authSession?.currentUser = user

				return user
			}
	}

	public func handle(url: URL) {
		WeDeployAuth.urlRedirect.on(.next(url))
	}

	public func signInWithRedirect(provider: AuthProvider, onSignIn: @escaping (User?, Error?) -> ()) {
		let authUrl = self.url
		WeDeployAuth.tokenSubscription?.dispose()
		
		WeDeployAuth.tokenSubscription = WeDeployAuth.urlRedirect
			.subscribe(onNext: { url in
				let token = url.absoluteString.components(separatedBy: "access_token=")[1]
				let auth = TokenAuth(token: token)

				self.authorization = auth
				WeDeploy.authSession?.currentAuth = auth

				self.getCurrentUser()
					.tap { result in
						switch result {
						case .fulfilled(let user):
							onSignIn(user, nil)
						case .rejected(let error):
							onSignIn(nil, error)
						}
					}
				})

		var url = URLComponents(string: "\(authUrl)/oauth/authorize")!
		url.queryItems = provider.providerParams


		open(url.url!)
	}

	public func createUser(email: String, password: String, name: String?) -> Promise<User> {
		var body = [
					"email" : email,
					"password" : password
				]

		if let name = name {
			body["name"] = name
		}

		return RequestBuilder
				.url(self.url)
				.path("/users")
				.post(body: body as AnyObject?)
				.then { response -> Promise<User> in

					return Promise<User> { fulfill, reject in
						do {
							let body = try response.validate()

							fulfill(User(json: body))
						} catch let error {
							reject(error)
						}
					}
				}
	}

	public func updateUser(id: String, email: String? = nil, password: String? = nil, name: String? = nil, photoUrl: String? = nil) -> Promise<Void> {
		var body = [String : String]()

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

		return RequestBuilder
			.url(self.url)
			.path("/users")
			.path("/\(id)")
			.authorize(auth: authorization)
			.patch(body: body as AnyObject?)
			.then { response -> Promise<Void> in

				return Promise<Void> { fulfill, reject in
					if response.statusCode == 204 {
						fulfill(())
					}
					else {
						reject(WeDeployError.errorFrom(response: response))
					}
				}
		}
	}

	public func getUser(id: String) -> Promise<User> {
		return RequestBuilder
				.url(self.url)
				.path("/users")
				.path("/\(id)")
				.authorize(auth: authorization)
				.get()
				.then { response -> Promise<User> in

					return Promise<User> { fulfill, reject in
						do {
							let body = try response.validate()

							fulfill(User(json: body))
						} catch let error {
							reject(error)
						}
					}
				}
	}

	public func sendPasswordReset(email: String) -> Promise<Void> {
		return RequestBuilder
				.url(self.url)
				.path("/user/recover")
				.form(name: "email", value: email)
				.post()
				.then { response -> Promise<Void> in

				 	return Promise<Void> { fulfill, reject in
						if response.statusCode == 200 {
							fulfill(())
						}
						else {
							reject(WeDeployError.errorFrom(response: response))
						}
					}
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
				.then { [weak self] response in
					self?.authorization = nil
					self?.currentUser = nil

					WeDeploy.authSession?.currentAuth = nil
					WeDeploy.authSession?.currentUser = nil

					return Promise<Void> { fulfill, reject in
						if response.statusCode == 200 {
							fulfill(())
						}
						else {
							reject(WeDeployError.errorFrom(response: response))
						}
					}
				}
	}

	func open(_ url: URL) {
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		else {
			UIApplication.shared.openURL(url)
		}
	}

}

