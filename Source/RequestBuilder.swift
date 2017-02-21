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


public class RequestBuilder {

	var authorization: Auth?
	var headers = [String: String]()
	var path = ""
	var transport: Transport = NSURLSessionTransport()
	var formFields = [String: String]()
	var requestMethod: RequestMethod = .GET
	var body: Any?

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

		body = formBody()

		return self
	}

	public func get() -> Promise<Response> {
		requestMethod = .GET

		return doCall()
	}

	public func post(body: Any? = nil) -> Promise<Response> {
		requestMethod = .POST

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func patch(body: Any? = nil) -> Promise<Response> {
		requestMethod = .PATCH

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func put(body: Any? = nil) -> Promise<Response> {
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
				params: self.params, body: self.body)

			self.authorization?.authenticate(request: request)

			self.transport.send(request: request, success: fulfill, failure: reject)
		}
	}

	private func formBody() -> String? {
		guard !formFields.isEmpty else {
			return nil
		}

		return formFields.reduce([]) { (result, element: (key: String, value: String)) -> [String] in
			result + [element.key + "=" + (element.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? element.value)]
		}
		.joined(separator: "&")
	}

}
