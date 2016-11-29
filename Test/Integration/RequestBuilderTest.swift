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


	func testTestBody() {
		let exp = expectation(description: "")
		RequestBuilder.url("http://auth.easley84.wedeploy.io")
				.path(path: "/oauth/token")
				.param(name: "grant_type", value: "password")
				.param(name: "username", value: "test@test.com")
				.param(name: "password", value: "test")
				.get()
				.sendWithPromise()
				.done(block: { response, error in
					print(response!.body)
					print(error)
				})

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testTestBody1() {
		let exp = expectation(description: "")
		RequestBuilder.url("http://auth.easley84.wedeploy.io")
			.path(path: "/oauth/token")
			.param(name: "grant_type", value: "password")
			.param(name: "username", value: "test@test.com")
			.param(name: "password", value: "test")
			.get()
			.sendWithCallback(success: { (response) in
				print(response.body)
			}, failure: {(error) in
				print(error)
			})

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testTestBody2() {
		let exp = expectation(description: "")
		RequestBuilder.url("http://auth.easley84.wedeploy.io")
			.path(path: "/oauth/token")
			.param(name: "grant_type", value: "password")
			.param(name: "username", value: "test@test.com")
			.param(name: "password", value: "test")
			.get()
			.sendWithObservable()
			.subscribe(onNext: { (response: Response) in
				print(response.body)
			})

		waitForExpectations(timeout: 10, handler: nil)
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
