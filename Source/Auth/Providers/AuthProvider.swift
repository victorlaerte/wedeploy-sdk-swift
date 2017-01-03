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

	public enum Provider : String {
		case github = "github"
		case facebook = "facebook"
	}

	let provider: Provider
	let redirectUri: String

	var scope: String?

	public init(provider: Provider, redirectUri: String) {
		self.provider = provider
		self.redirectUri = redirectUri
	}

	var providerUrl: String {

		var url = ""
		url += "?provider=\(provider)"
		url += "&redirect_uri=\(redirectUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"

		if let scope = scope {
			url += "&scope=\(scope)"
		}

		return url
	}
	
}
