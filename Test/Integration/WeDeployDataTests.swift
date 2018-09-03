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
import PromiseKit

class WeDeployDataCreationTest: BaseTest {

	func testCreateResource() {
		let resource: [String: Any] = [
			"title": "a title",
			"description": "a description"
		]
		
		let (item, error) = WeDeploy.data(self.dataModuleUrl)
				.create(resource: "things", object: resource)
				.sync()
		
		XCTAssertNotNil(item)
		XCTAssertNil(error)
		
		if item != nil {
			XCTAssertEqual(item!["title"] as! String, resource["title"] as! String)
			XCTAssertEqual(item!["description"] as! String, resource["description"] as! String)
		}
	}

	func testCreateMultipleResources() {
		let resource1: [String: Any] = [
			"title": "a title",
			"description": "a description"
		]

		let resource2: [String: Any] = [
			"title": "another title",
			"description": "another description"
		]

		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.create(resource: "things", object: [resource1, resource2])
			.sync()

		XCTAssertNotNil(items)
		XCTAssertNil(error)

		if items != nil {
			XCTAssertEqual(items!["results"]!.count, 2)
		}
	}

}

class WeDeployDataTest: BaseTest {

	let collectionName = "things"

	var data: [[String: String]] = [
		["name": "aname1", "yearsOld": "10" ],
		["name": "aname2", "yearsOld": "15" ],
		["name": "aname3", "yearsOld": "20" ],
		["name": "aname4", "yearsOld": "25" ],
		["name": "aname5", "yearsOld": "35" ],
		["name": "aname6", "yearsOld": "45" ],
		["name": "aname7", "yearsOld": "55", "name2": "aname1" ]
	]

	override func setUp() {
		super.setUp()

		_ = WeDeploy.data(self.dataModuleUrl)
			.create(resource: collectionName, object: data).sync()
	}

	override func tearDown() {
		super.tearDown()

		_ = WeDeploy.data(self.dataModuleUrl)
			.delete(collectionOrResourcePath: collectionName)
			.sync()
	}

	func testWhereOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.get(resourcePath: collectionName)
			.sync()
		
		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 6)
		}
	}

	func testAnyOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.any(field: "yearsOld", value: ["20", "25"])
			.get(resourcePath: collectionName)
			.sync()
		
		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 2)
		}
	}

	func testCountOperator() {
		let (count, error) = WeDeploy.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.count()
			.get(resourcePath: collectionName, type: Int.self)
			.sync()
		
		XCTAssertNotNil(count)
		XCTAssertNil(error)
		XCTAssertEqual(count, 6)
	}

	func testLimitOperator() {
		 
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.limit(1)
			.get(resourcePath: collectionName)
			.sync()
		
		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 1)
		}
	}

	func testOrderAscOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .ASC)
			.get(resourcePath: collectionName)
			.sync()
		
		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 6)
			XCTAssertEqual(items![0]["yearsOld"] as? String, "15")
			XCTAssertEqual(items![1]["yearsOld"] as? String, "20")
			XCTAssertEqual(items![2]["yearsOld"] as? String, "25")
		}
	}

	func testOrderDescOperator() {
		let (items, error) = WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .DESC)
			.get(resourcePath: collectionName)
			.sync()
		
		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 6)
			XCTAssertEqual(items![0]["yearsOld"] as? String, "55")
			XCTAssertEqual(items![1]["yearsOld"] as? String, "45")
			XCTAssertEqual(items![2]["yearsOld"] as? String, "35")
		}
	}

	func testOffsetOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .ASC)
			.offset(1)
			.get(resourcePath: collectionName)
			.sync()

		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 5)
			XCTAssertEqual(items![0]["yearsOld"] as! String, "20")
		}
	}

	func testOffsetLimitOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .ASC)
			.limit(1)
			.offset(1)
			.get(resourcePath: collectionName)
			.sync()

		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 1)
			XCTAssertEqual(items![0]["yearsOld"] as? String, "20")
		}
	}

	func testFieldsOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.fields("name")
			.get(resourcePath: collectionName)
			.sync()

		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			for item in items! {
				XCTAssertNil(item["yearsOld"])
				XCTAssertNotNil(item["name"])
			}
		}
	}

	func testFieldsOperatorWithMoreThanOneField() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.fields("name", "yearsOld")
			.get(resourcePath: collectionName)
			.sync()

		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			for item in items! {
				XCTAssertNotNil(item["yearsOld"])
				XCTAssertNotNil(item["name"])
			}
		}
	}

	func testWildcardOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.wildcard(field: "name", value: "*me1")
			.get(resourcePath: collectionName)
			.sync()

		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(1, items!.count)
			XCTAssertEqual("aname1", items!.first!["name"] as! String)
		}
	}

	func testMultiMatchOperator() {
		let (items, error) = WeDeploy.data(self.dataModuleUrl)
			.multiMatch(fields: ["name", "name2"], value: "aname1")
			.get(resourcePath: collectionName)
			.sync()

		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(2, items!.count)
		}
	}
}
