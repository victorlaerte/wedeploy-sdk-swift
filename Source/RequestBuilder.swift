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

	public func get() -> Promise<Response> {
		requestMethod = .GET

		return doCall()
	}

	public func post(body: AnyObject? = nil) -> Promise<Response> {
		requestMethod = .POST

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func patch(body: AnyObject? = nil) -> Promise<Response> {
		requestMethod = .PATCH

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func put(body: AnyObject? = nil) -> Promise<Response> {
		requestMethod = .PUT

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func delete() -> Promise<Response> {
		requestMethod = .DELETE

		return doCall()
	}

	func doCall() -> Promise<Response> {
		return Promise<Response> { fulfill, reject in
			let request = Request(
				method: self.requestMethod, headers: self.headers, url: self.url,
				params: self.params, body: self.body as AnyObject?)

			self.authorization?.authenticate(request: request)

			self.transport.send(request: request, success: fulfill, failure: reject)
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
