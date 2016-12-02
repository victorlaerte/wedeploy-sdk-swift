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
import later
import RxSwift

public class WeDeployAuth : RequestBuilder {

	var currentUser: User?

	init(_ url: String, user: User? = nil, authorization: Auth? = nil) {
		super.init(url)

		self.currentUser = user
		self.authorization = authorization
	}

	public func signInWith(username: String, password: String) -> Promise<User> {
		return RequestBuilder.url(self._url).path("/oauth/token")
			.param(name: "grant_type", value: "password")
			.param(name: "username", value: username)
			.param(name: "password", value: password)
			.get()
			.then { response -> Promise<Auth> in

				return Promise<Auth> { fulfill, reject in
					do {
						let body = try self.validateResponse(response: response)
						let token = body["access_token"] as! String
						let auth = TokenAuth(token: token)

						self.authorization = auth
						WeDeploy.authSession?.currentAuth = auth

						fulfill(auth)

					} catch let error {
						reject(error)
					}

				}
			}
			.then { auth -> Promise<Response> in

				return RequestBuilder
						.url(self._url)
						.path("/user")
						.authorize(auth: auth)
						.get()

			}
			.then { (response: Response) -> User in
			
				let body = response.body as! [String : AnyObject]

				let user = User(json: body)

				self.currentUser = user
				WeDeploy.authSession?.currentUser = user

				return user
			}
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
				.url(self._url)
				.path("/users")
				.post(body: body as AnyObject?)
				.then { response -> Promise<User> in

					return Promise<User> { fulfill, reject in
						do {
							let body = try self.validateResponse(response: response)

							fulfill(User(json: body))
						} catch let error {
							reject(error)
						}
					}
				}
	}

	public func getUser(id: String) -> Promise<User> {
		return RequestBuilder
				.url(self._url)
				.path("/users")
				.path("/\(id)")
				.authorize(auth: authorization)
				.get()
				.then { response -> Promise<User> in

					return Promise<User> { fulfill, reject in
						do {
							let body = try self.validateResponse(response: response)

							fulfill(User(json: body))
						} catch let error {
							reject(error)
						}
					}
				}
	}

	public func sendPasswordReset(email: String) -> Promise<Void> {
		return RequestBuilder
				.url(self._url)
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

	public func signOut() {
		self.authorization = nil
		self.currentUser = nil

		WeDeploy.authSession?.currentAuth = nil
		WeDeploy.authSession?.currentUser = nil
	}


	func validateResponse(response: Response) throws -> [String : AnyObject] {
		guard response.statusCode == 200,
			let body = response.body as? [String : AnyObject]
		else {
			throw WeDeployError.errorFrom(response: response)
		}

		return body
	}
}
