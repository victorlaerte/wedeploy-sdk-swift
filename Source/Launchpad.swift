import Foundation
import later

public class Launchpad {

	var headers: [String: String] = [:]
	var params: [NSURLQueryItem] = [NSURLQueryItem]()
	var path: String = ""
	var transport: Transport = NSURLSessionTransport()
	var _url: String

	var url: String {
		return _url + path
	}

	public init(_ url: String) {
		self._url = url
	}

	public func delete() -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: Request.Verb.DELETE, headers: self.headers,
				url: self.url, params: self.params)

			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func get() -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				headers: self.headers, url: self.url, params: self.params)

			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func header(name: String, _ value: String) -> Self {
		headers[name] = value

		return self
	}

	public func param(name: String, _ value: String) -> Self {
		params.append(NSURLQueryItem(name: name, value: value))

		return self
	}

	public func params(params: [NSURLQueryItem]?) -> Self {
		if let p = params {
			self.params = p
		}

		return self
	}

	public func patch(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: Request.Verb.PATCH, headers: self.headers,
				url: self.url, params: self.params, body: body)

			self.transport.send(request, success: fulfill, failure: reject)
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
				method: Request.Verb.POST, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func put(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: Request.Verb.PUT, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func use(transport: Transport) -> Self {
		self.transport = transport

		return self
	}

}