import Foundation
import later
import RxSwift

public class WeDeployAuth : RequestBuilder {

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

		return self.path("/oauth/token")
			.param(name: "grant_type", value: "password")
			.param(name: "username", value: username)
			.param(name: "password", value: password)
			.get()
			.withPromise()
			.then { response -> Promise<Auth> in

				return Promise<Auth> { fulfill, reject in
					guard response.statusCode == 200,
						let body = response.body as? Dictionary<String, AnyObject>,
						let token = body["access_token"] as? String
						else {
							reject(WeDeployError.badRequest(message: response.body?.description ?? ""))
							return
					}

					let auth = OAuth(token: token)
					fulfill(auth)
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
				return user
			}
	}
}
