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

class WeDeployDataCreationTest: BaseTest {


	func testCreateResource() {
		let resource: [String: Any] = [
			"title" : "a title",
			"description": "a description"
		]

		let expect = expectation(description: "resource created")

		executeAuthenticated {
			WeDeploy.data(self.dataModuleUrl)
				.create(resource: "things", object: resource)
				.tap { result  in
					if case let .fulfilled(item) = result {
						XCTAssertEqual(item["title"] as! String, resource["title"] as! String)
						XCTAssertEqual(item["description"] as! String, resource["description"] as! String)

						expect.fulfill()
					}
					else {
						XCTFail()
					}
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testCreateMultipleResources() {
		let resource1: [String: Any] = [
			"title" : "a title",
			"description": "a description"
		]

		let resource2: [String: Any] = [
			"title" : "another title",
			"description": "another description"
		]

		let expect = expectation(description: "resources created")

		executeAuthenticated {
			WeDeploy.data(self.dataModuleUrl)
				.create(resource: "things", object: [resource1, resource2])
				.tap { result in
					if case let .fulfilled(items) = result {
						XCTAssertEqual(items.count, 2)
						XCTAssertEqual(items[0]["title"] as! String, resource1["title"] as! String)
						XCTAssertEqual(items[1]["title"] as! String, resource2["title"] as! String)

						expect.fulfill()
					}
					else {
						XCTFail()
					}
			}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

}


class WeDeployDataTest: BaseTest {

	let collectionName = "things"

	let data: [[String: String]] = [
		["name": "aname1" , "yearsOld": "10" ],
		["name": "aname2" , "yearsOld": "15" ],
		["name": "aname3" , "yearsOld": "20" ],
		["name": "aname4" , "yearsOld": "25" ],
		["name": "aname5" , "yearsOld": "35" ],
		["name": "aname6" , "yearsOld": "45" ],
		["name": "aname7" , "yearsOld": "55" ]
	]

	override func setUp() {
		super.setUp()

		let exp = expect(description: "filling data")

		WeDeploy.data(self.dataModuleUrl)
			.create(resource: collectionName, object: data as [[String: AnyObject]])
			.tap { _ in
				exp.fulfill()
			}

		waitForExpectations(timeout: 10, handler: nil)
	}

	override func tearDown() {
		super.tearDown()

		let exp = expect(description: "empty data")

		WeDeploy.data(self.dataModuleUrl)
			.delete(collectionOrResourcePath: collectionName)
			.tap { _ in
				exp.fulfill()
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testWhereOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.get(resourcePath: collectionName)
			.tap { result in
				if case let .fulfilled(items) = result {
					XCTAssertEqual(items.count, 6)

					exp.fulfill()
				}
				else {
					XCTFail()
				}
			}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testAnyOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.any(field: "yearsOld", value: ["20","25"])
			.get(resourcePath: collectionName)
			.tap { result in
				if case let .fulfilled(items) = result {
					XCTAssertEqual(items.count, 2)

					exp.fulfill()
				}
				else {
					XCTFail()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testCountOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.getCount(resourcePath: collectionName)
			.tap {	result in
				if case let .fulfilled(count) = result {
					XCTAssertEqual(count, 6)

					exp.fulfill()
				}
				else {
					XCTFail()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testLimitOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.limit(1)
			.get(resourcePath: collectionName)
			.tap {	result in
				if case let .fulfilled(items) = result {
					XCTAssertEqual(items.count, 1)

					exp.fulfill()
				}
				else {
					XCTFail()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testOrderAscOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .ASC)
			.get(resourcePath: collectionName)
			.tap { result in
				if case let .fulfilled(items) = result {
					XCTAssertEqual(items.count, 6)

					XCTAssertEqual(items[0]["yearsOld"] as? String, "15")
					XCTAssertEqual(items[1]["yearsOld"] as? String, "20")
					XCTAssertEqual(items[2]["yearsOld"] as? String, "25")

					exp.fulfill()
				}
				else {
					XCTFail()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testOrderDescOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .DESC)
			.get(resourcePath: collectionName)
			.tap { result in
				if case let .fulfilled(items) = result {
					XCTAssertEqual(items.count, 6)

					XCTAssertEqual(items[0]["yearsOld"] as? String, "55")
					XCTAssertEqual(items[1]["yearsOld"] as? String, "45")
					XCTAssertEqual(items[2]["yearsOld"] as? String, "35")

					exp.fulfill()
				}
				else {
					XCTFail()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testOffsetOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .ASC)
			.offset(1)
			.get(resourcePath: collectionName)
			.tap { result in
				if case let .fulfilled(items) = result {
					XCTAssertEqual(items.count, 5)
					XCTAssertEqual(items[0]["yearsOld"] as? String ?? "0", "20")

					exp.fulfill()
				}
				else {
					XCTFail()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testOffsetLimitOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.orderBy(field: "yearsOld", order: .ASC)
			.limit(1)
			.offset(1)
			.get(resourcePath: collectionName)
			.tap {	result in
				if case let .fulfilled(items) = result {
					XCTAssertEqual(items.count, 1)
					XCTAssertEqual(items[0]["yearsOld"] as? String, "20")

					exp.fulfill()
				}
				else {
					XCTFail()
				}

		}

		waitForExpectations(timeout: 10, handler: nil)
	}

}
