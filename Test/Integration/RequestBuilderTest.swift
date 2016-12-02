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

@testable import WeDeploy
import XCTest
import later

class RequestBuilderTest : XCTestCase {

	func testFormBody() {

		let requestBuilder = RequestBuilder
			.url("test@test.com")
			.form(name: "name1", value: "value1")
			.form(name: "name2", value: "value2")

		XCTAssertEqual(requestBuilder.body as! String, "name1=value1&name2=value2")
		XCTAssertEqual(requestBuilder.headers["Content-Type"]!, "application/x-www-form-urlencoded")
	}

}


class MockTransport : Transport {

	var request : Request?

	func send(
		request: Request, success: @escaping (Response) -> (),
		failure: @escaping (Error) -> ()) {

		self.request = request

		let data = "".data(using: .utf8)
		success(Response(statusCode: 200, headers: [:], body: data!))
	}
	
}
