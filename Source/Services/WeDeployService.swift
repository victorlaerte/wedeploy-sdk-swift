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

public class WeDeployService {

	var authorization: Auth?
	var headers = [String: String]()
	let url: String

	var requestBuilder: RequestBuilder {
		let requestBuilder = RequestBuilder(url).authorize(auth: authorization)
		requestBuilder.headers = headers

		return requestBuilder
	}

	init(_ url: String, authorization: Auth? = nil) {
		self.url = url
		self.authorization = authorization
	}

	public func authorize(auth: Auth?) -> Self {
		authorization = auth
		return self
	}

	public func header(name: String, value: String) -> Self {
		var newValue = value
		if let currentValue = headers[name] {
			newValue = "\(currentValue), \(value)"
		}
		headers[name] = newValue
		return self
	}
}
