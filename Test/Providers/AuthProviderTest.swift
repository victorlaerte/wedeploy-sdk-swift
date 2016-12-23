//
//  AuthProviderTest.swift
//  WeDeploy
//
//  Created by Victor Galán on 23/12/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import XCTest
@testable import WeDeploy

class AuthProviderTest: XCTestCase {
    
	func testProviderShouldReturnCorrectProviderName() {
		let providerGithub = AuthProvider(provider: .github, redirectUri: "")
		let providerFacebook = AuthProvider(provider: .facebook, redirectUri: "")

		XCTAssertTrue(providerGithub.providerUrl.contains("github"))
		XCTAssertTrue(providerFacebook.providerUrl.contains("facebook"))

	}

	func testProviderShouldIncludeRedirectUriInProviderUrl() {
		let provider = AuthProvider(provider: .github, redirectUri: "someurl")

		XCTAssertEqual("?provider=github&redirect_uri=someurl", provider.providerUrl)
	}

	func testProviderShouldIncludeScopeIfExist() {
		let providerWithoutScope = AuthProvider(provider: .github, redirectUri: "someurl")
		let providerWithScope = AuthProvider(provider: .github, redirectUri: "someurl")
		providerWithScope.scope = "someScope"

		XCTAssertFalse(providerWithoutScope.providerUrl.contains("scope"))

		XCTAssertEqual("?provider=github&redirect_uri=someurl&scope=someScope", providerWithScope.providerUrl)
	}
    
}

