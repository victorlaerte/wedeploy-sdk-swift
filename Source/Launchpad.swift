import Foundation
import later
import SocketIO

public struct WeDeployAuth {

	let url: String
	let transport = NSURLSessionTransport()

	public func signInWithEmailAndPassword(username: String, password: String) -> Promise<Response> {
		let promise = Promise<Response> { (fulfill, reject) in

			let userParam = URLQueryItem(name: "username", value: username)
			let passParam = URLQueryItem(name: "password", value: password)
			let grantTypeParam = URLQueryItem(name: "grant_type", value: "password")

			let url = "\(self.url)/oauth/token"

			let request = Request(headers: nil, url: url, params: [userParam, passParam, grantTypeParam])

			self.transport.send(request: request, success: fulfill, failure: reject)
		}

		return promise
	}
}
public class Launchpad {

	var auth: Auth?
	var headers = [String: String]()
	var path = ""
	var query = Query()
	var transport: Transport = NSURLSessionTransport()

	var params: [URLQueryItem] {
		return _params + query.query.asQueryItems
	}

	var url: String {
		return _url + path
	}

	var _params = [URLQueryItem]()
	var _url: String

	public init(_ url: String) {
		_url = url
	}

	public class func url(url: String) -> Launchpad {
		return Launchpad(url)
	}

	public func auth(auth: Auth) -> Self {
		self.auth = auth
		return self
	}

	public func count() -> Self {
		query.count()
		return self
	}

	public func delete() -> Promise<Response> {

		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .DELETE, headers: self.headers, url: self.url,
				params: self.params)

			self.auth?.authenticate(request: request)
			self.transport.send(request: request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func filter(field: String, _ value: AnyObject) -> Self {
		query.filter(field: field, value)
		return self
	}

	public func filter(field: String, _ op: String, _ value: AnyObject)
		-> Self {

		//query.filter(field, op, value)
		return self
	}

	public func filter(filter: Filter) -> Self {
		//query.filter(filter)
		return self
	}

	public func get() -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				headers: self.headers, url: self.url, params: self.params)

			self.auth?.authenticate(request: request)
			self.transport.send(request: request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func header(name: String, _ value: String) -> Self {
		headers[name] = value
		return self
	}

	public func limit(limit: Int) -> Self {
		query.limit(limit: limit)
		return self
	}

	public func offset(offset: Int) -> Self {
		query.offset(offset: offset)
		return self
	}

	public func param(name: String, _ value: String) -> Self {
		_params.append(URLQueryItem(name: name, value: value))
		return self
	}

	public func patch(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .PATCH, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.auth?.authenticate(request: request)
			self.transport.send(request: request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func path(path: String) -> Self {
		self.path += path
		return self
	}

	public func post(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .POST, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.auth?.authenticate(request: request)
			self.transport.send(request: request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func put(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .PUT, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.auth?.authenticate(request: request)
			self.transport.send(request: request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func sort(name: String, order: Query.Order = .ASC) -> Self {
		query.sort(name: name, order: order)
		return self
	}

	public func use(transport: Transport) -> Self {
		self.transport = transport
		return self
	}

//	public func watch(options: Set<SocketIOClientOption> = [])
//		-> SocketIOClient {
//
//		return SocketIOClientFactory.create(
//			self.url, params: self.params, options: options)
//	}

}
