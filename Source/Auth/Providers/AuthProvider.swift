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

public class AuthProvider {

	public enum Provider: String {
		case github
		case facebook
		case google
	}

	public let provider: Provider
	public let redirectUri: String

	public var scope: String?
	public var providerScope: String?

	public init(provider: Provider, redirectUri: String) {
		self.provider = provider
		self.redirectUri = redirectUri

	}

	var providerParams: [URLQueryItem] {

		var queryItems = [URLQueryItem]()

		queryItems.append(URLQueryItem(name: "provider", value: provider.rawValue))

		if let providerScope = providerScope {
			queryItems.append(URLQueryItem(name: "provider_scope", value: providerScope))
		}
		else if provider == .google {
			queryItems.append(URLQueryItem(name: "provider_scope", value: "email"))
		}

		if let scope = scope {
			queryItems.append(URLQueryItem(name: "scope", value: scope))
		}

		queryItems.append(URLQueryItem(name: "redirect_uri", value: redirectUri))

		return queryItems
	}

}
