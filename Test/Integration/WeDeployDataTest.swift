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
import PromiseKit

class WeDeployDataCreationTest: BaseTest {

	func testCreateResource() {
		let resource: [String: Any] = [
			"title": "a title",
			"description": "a description"
		]
		let auth = givenAnAuth()
		
		let (item, error) = WeDeploy.data(self.dataModuleUrl, authorization: auth)
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
		let auth = givenAnAuth()

		
		let (items, error) = WeDeploy.data(self.dataModuleUrl, authorization: auth)
			.create(resource: "things", object: [resource1, resource2])
			.sync()
		
		XCTAssertNotNil(items)
		XCTAssertNil(error)
		if items != nil {
			XCTAssertEqual(items!.count, 2)
			XCTAssertEqual(items![0]["title"] as? String, resource1["title"] as? String)
			XCTAssertEqual(items![1]["title"] as? String, resource2["title"] as? String)
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
		["name": "aname7", "yearsOld": "55" ]
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

}
