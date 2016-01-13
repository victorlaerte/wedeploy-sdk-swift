@testable import Launchpad
import XCTest

class DictionaryExtensionTest : XCTestCase {

	func testExtension() {
		let dic = [
			"string": "value",
			"1": 2,
			"object": [
				"title": "book",
				"year": 1982
			],
			"array": [1, 2, 3]
		]

		let items = dic.asQueryItems

		XCTAssertEqual(dic.count, items.count)
	}

}
