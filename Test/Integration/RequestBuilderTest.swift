//
//  RequestBuilderTest.swift
//  Launchpad
//
//  Created by Victor Galán on 28/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

@testable import Launchpad
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
