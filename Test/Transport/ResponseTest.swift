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

class ResponseTest : XCTestCase {

	func testEmptyData() {
		let data = "".data(using: .utf8)

		let headers = ["Content-Type": "text/html; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)

		XCTAssertNil(response.body)
	}

	func testHTML() {
		let data = "<html></html>".data(using: .utf8)

		let headers = ["Content-Type": "text/html; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)
		let body = response.body as! String

		XCTAssertEqual("<html></html>", body)
	}

	func testJSON() {
		let data = "{\"foo\": \"bar\"}".data(using: .utf8)


		let headers = ["Content-Type": "application/json; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)
		let body = response.body as! [String: String]

		XCTAssertEqual("bar", body["foo"] as String!)
	}

	func testMalformedJSON() {
		let data = "{\"foo\": \"bar".data(using: .utf8)


		let headers = ["Content-Type": "application/json; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)
		let body = response.body as! String

		XCTAssertEqual("{\"foo\": \"bar", body)
	}

}
