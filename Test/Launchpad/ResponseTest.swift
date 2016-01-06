@testable import Launchpad
import XCTest

class ResponseTest : XCTestCase {

	func testEmptyData() {
		let data = "".dataUsingEncoding(NSUTF8StringEncoding)

		let headers = ["Content-Type": "text/html; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)

		XCTAssertNil(response.body)
	}

	func testHTML() {
		let data = "<html></html>".dataUsingEncoding(NSUTF8StringEncoding)

		let headers = ["Content-Type": "text/html; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)
		let body = response.body as! String

		XCTAssertEqual("<html></html>", body)
	}

	func testJSON() {
		let data = "{\"foo\": \"bar\"}".dataUsingEncoding(
			NSUTF8StringEncoding)

		let headers = ["Content-Type": "application/json; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)
		let body = response.body as! [String: String]

		XCTAssertEqual("bar", body["foo"] as String!)
	}

	func testMalformedJSON() {
		let data = "{\"foo\": \"bar".dataUsingEncoding(
			NSUTF8StringEncoding)

		let headers = ["Content-Type": "application/json; charset=UTF-8"]
		let response = Response(statusCode: 200, headers: headers, body: data!)
		let body = response.body as! String

		XCTAssertEqual("{\"foo\": \"bar", body)
	}

}