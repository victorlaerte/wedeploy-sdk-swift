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

import XCTest
@testable import WeDeploy

class AuthProviderTest: XCTestCase {

	func testProviderShouldReturnCorrectProviderName() {
		let providerGithub = AuthProvider(provider: .github, redirectUri: "")
		let providerFacebook = AuthProvider(provider: .facebook, redirectUri: "")

		let githubQuery = providerGithub.providerParams.filter { $0.name == "provider" }[0]
		let facebookQuery = providerFacebook.providerParams.filter { $0.name == "provider" }[0]

		XCTAssertEqual(githubQuery.value, "github")
		XCTAssertEqual(facebookQuery.value, "facebook")

	}

	func testProviderShouldIncludeRedirectUriInProviderUrl() {
		let provider = AuthProvider(provider: .github, redirectUri: "someurl")

		let redirectParam = provider.providerParams.filter { $0.name == "redirect_uri" }[0]

		XCTAssertEqual(redirectParam.value, "someurl")
	}

	func testProviderShouldIncludeScopeIfExist() {
		let providerWithScope = AuthProvider(provider: .github, redirectUri: "someurl")
		providerWithScope.scope = "someScope"

		let scopeParam = providerWithScope.providerParams.filter { $0.name == "scope" }[0]

		XCTAssertEqual(scopeParam.value, "someScope")
	}

}
