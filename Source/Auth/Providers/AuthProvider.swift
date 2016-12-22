//
//  AuthProvider.swift
//  WeDeploy
//
//  Created by Victor Galán on 22/12/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

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
