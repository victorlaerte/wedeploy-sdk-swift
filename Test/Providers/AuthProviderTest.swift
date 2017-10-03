/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* 3. Neither the name of Liferay, Inc. nor the names of its contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
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
