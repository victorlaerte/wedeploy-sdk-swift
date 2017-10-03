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

