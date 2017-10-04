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

class CollectionFieldTypeTests: XCTestCase {
    
    func testCollectionFieldTypesOneLevel() {
		let oneLevelCollection: [String : CollectionFieldType] = [
			"field1" : .string,
			"field2" : .geoPoint,
			"field3" : .geoShape
		]

		let jsonConvertible = oneLevelCollection.toJsonConvertible()

		let expected: [String : String] = [
			"field1" : "string",
			"field2" : "geo_point",
			"field3" : "geo_shape"
		]

		XCTAssertTrue(NSDictionary(dictionary: expected).isEqual(to: jsonConvertible))
    }


	func testCollectionFieldTypesTwoLevels() {
		let oneLevelCollection: [String : CollectionFieldType] = [
			"field1" : .string,
			"field2" : .collectionFieldType(fields:
				[
					"innerField1" : .string,
					"innerField2" : .geoPoint
				]),
			"field3" : .geoShape
		]

		let jsonConvertible = oneLevelCollection.toJsonConvertible()

		let expected: [String : Any] = [
			"field1" : "string",
			"field2" : [
				"innerField1" : "string",
				"innerField2" : "geo_point"
				],
			"field3" : "geo_shape"
		]

		XCTAssertTrue(NSDictionary(dictionary: expected).isEqual(to: jsonConvertible))
	}

	func testCollectionFieldTypesThreeLevels() {
		let oneLevelCollection: [String : CollectionFieldType] = [
			"field1" : .string,
			"field2" : .collectionFieldType(fields:
				[
					"innerField1" : .collectionFieldType(fields:
						[
							"innerInnerField1": .binary
						]),
					"innerField2" : .geoPoint
				]),
			"field3" : .geoShape
		]

		let jsonConvertible = oneLevelCollection.toJsonConvertible()

		let expected: [String : Any] = [
			"field1" : "string",
			"field2" : [
				"innerField1" : [
					"innerInnerField1" : "binary"
				],
				"innerField2" : "geo_point"
			],
			"field3" : "geo_shape"
		]

		XCTAssertTrue(NSDictionary(dictionary: expected).isEqual(to: jsonConvertible))
	}
    
}
