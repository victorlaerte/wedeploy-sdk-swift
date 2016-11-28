import Foundation
import later

public struct WeDeployAuth {

	let url: String
	let transport = NSURLSessionTransport()

	public func signInWithEmailAndPassword(username: String, password: String) -> Promise<User> {
		let promise = Promise<Response> { (fulfill, reject) in

			let userParam = URLQueryItem(name: "username", value: username)
			let passParam = URLQueryItem(name: "password", value: password)
			let grantTypeParam = URLQueryItem(name: "grant_type", value: "password")

			let url = "\(self.url)/oauth/token"

			let request = Request(headers: nil, url: url, params: [userParam, passParam, grantTypeParam])

			self.transport.send(request: request, success: { response in
				guard response.statusCode == 200,
					let body = response.body as? Dictionary<String, AnyObject>,
					let token = body["access_token"] as? String
					else {
						reject(NSError(domain: "WeDeploy", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"]))
						return
				}

				let auth = OAuth(token: token)
				LaunchPad.currentAuth = auth
				fulfill(response)
			},
			failure: reject)
		}.then { response -> Promise<Response> in
			let url = "\(self.url)/user"
			return LaunchPad(url).auth().get()
		}.then { (response: Response) -> User in
			let body = response.body as! Dictionary<String, AnyObject>

			let user = User(json: body)
			LaunchPad.currentUser = user

			return user
		}


		return promise
	}

//	internal func getToken(username: String, password: String) -> Promise<Response> {
//		let promise = Promise<Response> { (fulfill, reject) in
//
//			let userParam = URLQueryItem(name: "username", value: username)
//			let passParam = URLQueryItem(name: "password", value: password)
//			let grantTypeParam = URLQueryItem(name: "grant_type", value: "password")
//
//			let url = "\(self.url)/oauth/token"
//
//			let request = Request(
//					headers: nil,
//					url: url,
//					params: [userParam, passParam, grantTypeParam])
//
//			self.transport.send(request: request, success: { response in
//				guard response.statusCode == 200,
//					let token = self.parseToken(response: response)
//					else {
//						reject(NSError(domain: "WeDeploy", code: 1,
//								userInfo: [NSLocalizedDescriptionKey: "Unauthorized"]))
//						return
//				}
//
//				let auth = OAuth(token: token)
//
//				fulfill(response)
//			},
//			failure: reject)
//		}
//
//		return promise
//	}
//
//	internal func parseToken(response: Response) -> String? {
//		if let body = response.body as? Dictionary<String, AnyObject>,
//		  	let token = body["access_token"] as? String {
//
//			return token
//		}
//
//		return nil
//	}
//
//	internal func getCurrentUser(auth: OAuth) -> Promise<User> {
//		return WeDeploy(url).auth(auth: auth).get()
//			.then { response -> Promise<User> in
//				let body = response.body as! Dictionary<String, AnyObject>
//
//				return User(json: body)
//			}
//	}
}
