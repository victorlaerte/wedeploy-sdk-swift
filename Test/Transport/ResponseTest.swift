@testable import Launchpad
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
