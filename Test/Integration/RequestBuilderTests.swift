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

@testable import WeDeploy
import XCTest

class RequestBuilderTest: XCTestCase {

	func testFormBody() {

		let requestBuilder = RequestBuilder
			.url("test@test.com")
			.form(name: "name1", value: "value1")
			.form(name: "name2", value: "value2")

		XCTAssertEqual(requestBuilder.body as! String, "name1=value1&name2=value2")
		XCTAssertEqual(requestBuilder.headers["Content-Type"]!, "application/x-www-form-urlencoded")
	}

	func testHeadersWithSameName() {

		let requestBuilder = RequestBuilder.url("test.com")
			.header(name: "HeaderName", value: "HeaderValue1")
			.header(name: "HeaderName", value: "HeaderValue2")
			.header(name: "HeaderName", value: "HeaderValue3")

		XCTAssertEqual(requestBuilder.headers["HeaderName"], "HeaderValue1, HeaderValue2, HeaderValue3")
	}

}

class MockTransport: Transport {

	var request: Request?

	func send(
		request: Request, success: @escaping (Response) -> Void,
		failure: @escaping (Error) -> Void) {

		self.request = request

		let data = "".data(using: .utf8)
		success(Response(statusCode: 200, headers: [:], body: data!))
	}

}
