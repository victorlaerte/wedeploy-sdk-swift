//
//  WeDeployDataTest.swift
//  WeDeploy
//
//  Created by Victor Galán on 27/12/2016.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

@testable import WeDeploy
import later
import RxSwift
import XCTest

class WeDeployDataTest: BaseTest {

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

		let expect = expectation(description: "resource created")

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
