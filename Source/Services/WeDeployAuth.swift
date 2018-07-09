/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* 3. Neither the name of Liferay, Inc. nor the names of its contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

#if os(macOS)
	import AppKit
#else
	import UIKit
#endif

import Foundation
import PromiseKit
import RxSwift

/// Helper to communicate with Auth service in WeDeploy.
///
/// ```
///	WeDeploy.email("auth-service-url")
///		.signInWith(username: String, password: String)
///		.then { auth -> Void in
///			// Do something with the auth.
/// 	}
///		.catch { error in
///			// Do something with the error.
/// 	}
/// ```
public class WeDeployAuth: WeDeployService {

	static var urlRedirect = PublishSubject<URL>()
	static var tokenSubscription: Disposable?

	/// Authorize the request with the given authentication.
	///
	/// - returns: the object itself, so calls can be chained.
	public override func authorize(auth: Auth?) -> WeDeployAuth {
		return super.authorize(auth: auth) as! WeDeployAuth
	}

	/// Add a header to the request.
	///
	/// - returns: the object itself, so calls can be chained.
	public override func header(name: String, value: String) -> WeDeployAuth {
		return super.header(name: name, value: value) as! WeDeployAuth
	}

	/// Sign in using username and password.
	///
	/// - returns: a promise containing the authentication
	public func signInWith(username: String, password: String) -> Promise<Auth> {
		return requestBuilder.path("/oauth/token")
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

	/// Get the user that is logged in.
	///
	/// - note: You should authenticate the request with the user logged token.
	///
	/// - returns: a promise containing the authentication
	public func getCurrentUser() -> Promise<User> {
		return requestBuilder.path("/user")
			.get()
			.then { (response: Response) -> User in
				let body = try response.validate()

				return User(json: body)
			}
	}

	/// Sign in using the given provider.
	///
	/// - parameter provider: 3rd party service using in the log in.
	/// - parameter onSignIn: function that will be called after the login flow its finished.
	///		Including after calling handle(url:) method of this class.
	public func signInWithRedirect(provider: AuthProvider, onSignIn: @escaping (Auth?, Error?) -> Void) {
		let authUrl = self.url
		WeDeployAuth.tokenSubscription?.dispose()

		WeDeployAuth.tokenSubscription = WeDeployAuth.urlRedirect
			.subscribe(onNext: { url in
				let urlParts = url.absoluteString.components(separatedBy: "access_token=")
				if urlParts.count == 2 {
					let auth = TokenAuth(token: urlParts[1])
					onSignIn(auth, nil)
				}
				else {
					onSignIn(nil, WeDeployProviderError.noAccessToken)
				}
			})

		var url = URLComponents(string: "\(authUrl)/oauth/authorize")!
		url.queryItems = provider.providerParams

		open(url.url!)
	}

	/// Handle the url given. This method is used in the Provider login method.
	///
	/// - note: this method should be called in the application
	///		delegation after user clicked in a link that opened the application.
	///
	public func handle(url: URL) {
		WeDeployAuth.urlRedirect.on(.next(url))
	}

	/// Create a user with the given arguments.
	///
	/// - returns: a promise containing the user
	public func createUser(email: String, password: String, name: String?,
		photoUrl: String? = nil, attrs: [String: Any] = [:]) -> Promise<User> {

		var body: [String: Any] = [
					"email": email,
					"password": password
				]

		if let name = name {
			body["name"] = name
		}

		if let photoUrl = photoUrl {
			body["photoUrl"] = photoUrl
		}

		for (key, element) in attrs {
			body[key] = element
		}

		return requestBuilder
				.path("/users")
				.post(body: body as AnyObject?)
				.then { response -> User in
					let body = try response.validate()
					return User(json: body)
				}
	}

	/// Update a user with the given arguments.
	public func updateUser(id: String, email: String? = nil, password: String? = nil,
			name: String? = nil, photoUrl: String? = nil, attrs: [String: Any] = [:] ) -> Promise<Void> {

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

		return requestBuilder
			.path("/users")
			.path("/\(id)")
			.patch(body: body)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	/// Delete a user with the given id.
	public func deleteUser(id: String) -> Promise<Void> {
		return requestBuilder
			.path("/users")
			.path("/\(id)")
			.delete()
			.then { response  in
				try response.validateEmptyBody()
			}
	}

	/// Get a user with the given id.
	///
	/// - returns: a promise containing the user
	public func getUser(id: String) -> Promise<User> {
		return requestBuilder
				.path("/users")
				.path("/\(id)")
				.get()
				.then { response -> User in
					let body = try response.validate()
					return User(json: body)
				}
	}

	/// Trigger a email sent for resetting the password.
	public func sendPasswordReset(email: String) -> Promise<Void> {
		return requestBuilder
				.path("/user/recover")
				.form(name: "email", value: email)
				.post()
				.then { response in
				 	try response.validateEmptyBody()
				}
	}

	/// Get all users of the service.
	///
	/// - returns: a promise containing an array of users
	public func getAllUsers() -> Promise<[User]> {
		return requestBuilder
				.path("/users")
				.get()
				.then { response -> [User] in
					let body = try response.validateBody(bodyType: [[String: AnyObject]].self)
					return body.map(User.init)
				}

	}

	/// Sign out. Invalidates the user token.
	public func signOut() -> Promise<Void> {
		precondition(self.authorization != nil && self.authorization is TokenAuth,
				"you have to have an authentication to sign out")

		let token = (self.authorization as! TokenAuth).token
		return requestBuilder
				.path("/oauth/revoke")
				.param(name: "token", value: token)
				.get()
				.then { response -> Void in
					return try response.validateEmptyBody()
				}
	}

	#if os(macOS)

	/// Opens the given URL into safari
	func open(_ url: URL) {
		NSWorkspace.shared.open(url)
	}

	#else

	/// Opens the given URL into safari
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
