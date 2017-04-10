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


import Foundation
import PromiseKit
import RxSwift
import XCTest
@testable import WeDeploy

class PromiseKitExtensionsTest: XCTestCase {

	var bag = DisposeBag()

	override func tearDown() {
		super.tearDown()
		
		bag = DisposeBag()
	}

	func testCallbackExtension_withPromiseWithFulfill() {
		let expect = XCTestExpectation(description: "should call callback method")
		let promise = Promise { fulfill, _ in
			fulfill()
		}

		promise.toCallback { value, error in
			XCTAssertNotNil(value)
			XCTAssertNil(error)
			expect.fulfill()
		}

		XCTWaiter.wait(for: [expect], timeout: 1)
	}

	func testCallbackExtension_withPromiseWithReject() {
		let expect = XCTestExpectation(description: "should call callback method")

		let promise = Promise<Any>(error: TestError.empty)

		promise.toCallback { value, error in
			XCTAssertNil(value)
			XCTAssertNotNil(error)
			XCTAssertTrue(error is TestError)
			expect.fulfill()
		}

		XCTWaiter.wait(for: [expect], timeout: 1)
	}

	func testCallbackExtension_withPromiseWithFulfillAndReject() {
		let expect = XCTestExpectation(description: "should call callback method")

		let promise: Promise<String> = Promise(value: "")
			.then {_ in 
				throw TestError.empty
			}

		promise.toCallback { value, error in
			XCTAssertNil(value)
			XCTAssertNotNil(error)
			XCTAssertTrue(error is TestError)
			expect.fulfill()
		}

		XCTWaiter.wait(for: [expect], timeout: 1)
	}

	func testObservableExtension_withPromiseWithFulfill() {
		let expect = XCTestExpectation(description: "should call observable method")
		let promise = Promise { fulfill, _ in
			fulfill()
		}

		promise.toObservable().subscribe(onNext: { value in
			XCTAssertNotNil(value)
			expect.fulfill()
		},onError: { error in
			XCTAssertNil(error)
			expect.fulfill()
		})
		.disposed(by: bag)

		XCTWaiter.wait(for: [expect], timeout: 1)
	}

	func testObservableExtension_withPromiseWithReject() {
		let expect = XCTestExpectation(description: "should call observable method")

		let promise = Promise<Any>(error: TestError.empty)

		promise.toObservable().subscribe(onNext: { _ in
			XCTFail("Should not call next when the promise failed")
			expect.fulfill()
		},onError: { error in
			XCTAssertNotNil(error)
			XCTAssertTrue(error is TestError)
			expect.fulfill()
		})
		.disposed(by: bag)

		XCTWaiter.wait(for: [expect], timeout: 1)
	}

	func testObservableExtension_withPromiseWithFulfillAndReject() {
		let expect = XCTestExpectation(description: "should call observable method")

		let promise = Promise(value: "")
			.then {_ in
				throw TestError.empty
		}

		promise.toObservable().subscribe(onNext: { _ in
			XCTFail("Should not call next when the promise failed")
			expect.fulfill()
		},onError: { error in
			XCTAssertNotNil(error)
			XCTAssertTrue(error is TestError)
			expect.fulfill()
		})
		.disposed(by: bag)

		XCTWaiter.wait(for: [expect], timeout: 1)
	}

}

