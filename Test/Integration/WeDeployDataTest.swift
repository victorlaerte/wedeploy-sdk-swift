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
import later
import XCTest

class WeDeployDataCreationTest: BaseTest {


	func testCreateResource() {
		let resource: [String: AnyObject] = [
			"title" : "a title" as AnyObject,
			"description": "a description" as AnyObject
		]

		let expect = expectation(description: "resource created")

		executeAuthenticated {
			WeDeploy.data(self.dataModuleUrl)
				.create(resource: "things", object: resource)
				.done { res, error in
					XCTAssertNil(error)
					XCTAssertNotNil(res)

					XCTAssertEqual(res!["title"] as! String, resource["title"] as! String)
					XCTAssertEqual(res!["description"] as! String, resource["description"] as! String)

					expect.fulfill()
				}
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testCreateMultipleResources() {
		let resource1: [String: AnyObject] = [
			"title" : "a title" as AnyObject,
			"description": "a description" as AnyObject
		]

		let resource2: [String: AnyObject] = [
			"title" : "another title" as AnyObject,
			"description": "another description" as AnyObject
		]

		let expect = expectation(description: "resources created")

		executeAuthenticated {
			WeDeploy.data(self.dataModuleUrl)
				.create(resource: "things", object: [resource1, resource2])
				.done { res, error in
					XCTAssertNil(error)
					XCTAssertNotNil(res)

					XCTAssertEqual(res!.count, 2)
					XCTAssertEqual(res![0]["title"] as! String, resource1["title"] as! String)
					XCTAssertEqual(res![1]["title"] as! String, resource2["title"] as! String)

					expect.fulfill()
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
			.done { _ ,_ in
				exp.fulfill()
			}

		waitForExpectations(timeout: 10, handler: nil)
	}

	override func tearDown() {
		super.tearDown()

		let exp = expect(description: "empty data")

		WeDeploy.data(self.dataModuleUrl)
			.delete(collectionOrResourcePath: collectionName)
			.done { _ ,_ in
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
			.done {	items, error in
				XCTAssertNil(error)
				XCTAssertNotNil(items)

				XCTAssertEqual(items?.count ?? 0, 6)

				exp.fulfill()
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
			.done {	items, error in
				XCTAssertNil(error)
				XCTAssertNotNil(items)

				XCTAssertEqual(items?.count ?? 0, 2)

				exp.fulfill()
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

	func testCountOperator() {
		let exp = expect(description: "where")

		WeDeploy
			.data(self.dataModuleUrl)
			.where(field: "yearsOld", op: ">", value: "14")
			.getCount(resourcePath: collectionName)
			.done {	count, error in
				XCTAssertNil(error)
				XCTAssertNotNil(count)

				XCTAssertEqual(count ?? 0, 6)

				exp.fulfill()
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
			.done {	items, error in
				XCTAssertNil(error)
				XCTAssertNotNil(items)

				XCTAssertEqual(items?.count ?? 0, 1)

				exp.fulfill()
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
			.done {	items, error in
				XCTAssertNil(error)
				XCTAssertNotNil(items)

				XCTAssertEqual(items?.count ?? 0, 6)

				XCTAssertEqual(items?[0]["yearsOld"] as? String ?? "0", "15")
				XCTAssertEqual(items?[1]["yearsOld"] as? String ?? "0", "20")
				XCTAssertEqual(items?[2]["yearsOld"] as? String ?? "0", "25")

				exp.fulfill()
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
			.done {	items, error in
				XCTAssertNil(error)
				XCTAssertNotNil(items)

				XCTAssertEqual(items?.count ?? 0, 6)

				XCTAssertEqual(items?[0]["yearsOld"] as? String ?? "0", "55")
				XCTAssertEqual(items?[1]["yearsOld"] as? String ?? "0", "45")
				XCTAssertEqual(items?[2]["yearsOld"] as? String ?? "0", "35")

				exp.fulfill()
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
			.done {	items, error in
				XCTAssertNil(error)
				XCTAssertNotNil(items)

				XCTAssertEqual(items?.count ?? 0, 5)

				XCTAssertEqual(items?[0]["yearsOld"] as? String ?? "0", "20")

				exp.fulfill()
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
			.done {	items, error in
				XCTAssertNil(error)
				XCTAssertNotNil(items)

				XCTAssertEqual(items?.count ?? 0, 1)

				XCTAssertEqual(items?[0]["yearsOld"] as? String ?? "0", "20")

				exp.fulfill()
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

}
