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
import SocketIO
import XCTest

class WatchTest: BaseTest {

	func testParseURLScheme() {
		let urlHttp = SocketIOClientFactory.parseURL(url: "http://domain.com")
		let urlHttps = SocketIOClientFactory.parseURL(url: "https://domain.com")

		XCTAssertEqual("http://domain.com", urlHttp.host)
		XCTAssertEqual("https://domain.com", urlHttps.host)
	}

	func testParseURL() {
		let url = SocketIOClientFactory.parseURL(url: "http://domain:8080/path/a")
		XCTAssertEqual("http://domain:8080", url.host)
		XCTAssertEqual("/path/a", url.path)
	}

	func testParseURL_With_Query() {
		let params = [
			URLQueryItem(name: "param1", value: "value1"),
			URLQueryItem(name: "param2", value: "value2")
		]

		let url = SocketIOClientFactory.parseURL(url: "http://domain:8080/path/a", params: params)

		XCTAssertEqual("http://domain:8080", url.host)
		XCTAssertEqual("/path/a", url.path)
		XCTAssertEqual("/path/a?param1=value1&param2=value2", url.query)
	}

}
