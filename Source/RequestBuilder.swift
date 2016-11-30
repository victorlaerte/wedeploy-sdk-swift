//
//  RequestBuilder.swift
//  Launchpad
//
//  Created by Victor Galán on 28/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation
import later
import RxSwift


public class RequestBuilder {

	var authorization: Auth?
	var headers = [String: String]()
	var path = ""
	var transport: Transport = NSURLSessionTransport()
	var formFields = [String: String]()
	var requestMethod: RequestMethod = .GET
	var body: AnyObject?

	var params = [URLQueryItem]()

	var url: String {
		return _url + path
	}

	var _url: String

	public init(_ url: String) {
		self._url = url
	}

	public class func url(_ url: String) -> RequestBuilder {
		return RequestBuilder(url)
	}

	public func param(name: String, value: String) -> Self {
		params.append(URLQueryItem(name: name, value: value))
		return self
	}

	public func header(name: String, value: String) -> Self {
		headers[name] = value
		return self
	}

	public func transport(_ transport: Transport) -> Self {
		self.transport = transport
		return self
	}

	public func authorize(auth: Auth?) -> Self {
		self.authorization = auth
		return self
	}

	public func path(_ path: String) -> Self {
		self.path += path
		return self
	}

	public func form(name: String, value: String) -> Self {
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		formFields[name] = value

		body = formBody() as AnyObject?

		return self
	}

	public func get() -> Self {
		requestMethod = .GET

		return self
	}

	public func post(body: AnyObject? = nil) -> Self {
		requestMethod = .POST

		if body != nil {
			self.body = body
		}

		return self
	}

	public func patch(body: AnyObject? = nil) -> Self {
		requestMethod = .PATCH

		if body != nil {
			self.body = body
		}

		return self
	}

	public func put(body: AnyObject? = nil) -> Self {
		requestMethod = .PUT

		if body != nil {
			self.body = body
		}

		return self
	}

	public func delete() -> Self {
		requestMethod = .DELETE

		return self
	}

	public func withPromise() -> Promise<Response> {

		return Promise<Response> { fulfill, reject in
			let request = Request(
				method: self.requestMethod, headers: self.headers, url: self.url,
				params: self.params, body: self.body as AnyObject?)

			self.authorization?.authenticate(request: request)

			self.transport.send(request: request, success: fulfill, failure: reject)
		}
	}

	public func withCallback(
			callback: @escaping (Response?, Error?) -> ()) {

		let request = Request(
			method: self.requestMethod, headers: self.headers, url: self.url,
			params: self.params, body: self.body as AnyObject?)

		self.authorization?.authenticate(request: request)

		self.transport.send(
			request: request,
			success: { callback($0, nil) },
			failure: { callback(nil, $0) })
	}

	public func withObservable() -> Observable<Response> {
		return Observable.create { observer in
			let request = Request(
				method: self.requestMethod, headers: self.headers, url: self.url,
				params: self.params, body: self.body as AnyObject?)

			self.authorization?.authenticate(request: request)

			self.transport.send(request: request, success: { response in

				observer.on(.next(response))
				observer.on(.completed)

			}, failure: { error in
				observer.on(.error(error))
			})

			return Disposables.create()
		}
	}


	private func formBody() -> String? {
		guard !formFields.isEmpty else {
			return nil
		}

		return formFields.map {
				($0.key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
		 			$0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
			}
			.reduce([], { $0 + [$1.0! + "=" + $1.1!]})
			.joined(separator: "&")
	}
}
