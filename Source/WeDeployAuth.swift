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

	public func signInWith(
			username: String, password: String, callback: @escaping (User?, Error?) -> ()) {

		signInWith(username: username, password: password).done(block: callback)
	}

	public func signInWith(
		username: String, password: String) -> Observable<User> {

		return Observable.create { observer in
			self.signInWith(username: username, password: password).done { user, error in
				if let user = user {
					observer.on(.next(user))
					observer.on(.completed)
				}
				else {
					observer.on(.error(error!))
				}
			}

			return Disposables.create()
		}
	}

	public func signInWith(username: String, password: String) -> Promise<User> {

		return RequestBuilder.url(self._url).path("/oauth/token")
			.param(name: "grant_type", value: "password")
			.param(name: "username", value: username)
			.param(name: "password", value: password)
			.get()
			.withPromise()
			.then { response -> Promise<Auth> in

				return Promise<Auth> { fulfill, reject in
					do {
						let body = try self.validateResponse(response: response)

						let token = body["access_token"] as! String

						let auth = OAuth(token: token)

						self.authorization = auth
						WeDeploy.authSession?.currentAuth = auth

						fulfill(auth)

					} catch let error {
						reject(error)
					}

				}
			}.then { auth -> Promise<Response> in

				return RequestBuilder
						.url(self._url)
						.path("/user")
						.authorize(auth: auth)
						.get()
						.withPromise()

			}.then { (response: Response) -> User in
			
				let body = response.body as! Dictionary<String, AnyObject>

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
				.withPromise()
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

	public func signOut() {
		self.authorization = nil
		self.currentUser = nil

		WeDeploy.authSession?.currentAuth = nil
		WeDeploy.authSession?.currentUser = nil
	}
	func validateResponse(response: Response) throws -> Dictionary<String, AnyObject> {
		guard response.statusCode == 200,
			let body = response.body as? Dictionary<String, AnyObject>
			else {
				throw WeDeployError.badRequest(message: response.body?.description ?? "")
			}

		return body
	}
}
