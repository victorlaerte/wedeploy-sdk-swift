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

import WeDeploy
import XCTest

class QueryTest: XCTestCase {

	func testComplex_Query() {
		let query = Query()
			.filter(filter: Filter.gt(field: "age", value: 12))
			.sort(name: "age", order: Query.Order.DESC)
			.sort(name: "name")
			.offset(offset: 5)
			.limit(limit: 10)

		assertJSON("{" +
			"\"limit\":10," +
			"\"sort\":[{\"age\":\"desc\"},{\"name\":\"asc\"}]," +
			"\"offset\":5," +
			"\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]," +
			"}",
			query.query)
	}

	func testFilter_With_Instance() {
		let query = Query().filter(filter: Filter.gt(field: "age", value: 12))

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]}",
			query.query)
	}

	func testFilter_With_Multiple_Filters() {
		let query = Query()
			.filter(filter: Filter.gt(field: "age", value: 12))
			.filter(field:"age", "<", 15)
			.filter(field:"name", "Foo")

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}," +
			"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
			"{\"name\":{\"operator\":\"=\",\"value\":\"Foo\"}}]}",
			query.query)
	}

	func testFilter_With_Operator() {
		let query = Query().filter(field: "age", ">", 12)

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]}",
			query.query)
	}

	func testFilter_With_Optional_Operator() {
		let query = Query().filter(field: "age", 12)

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\"=\",\"value\":12}}]}",
			query.query)
	}

	func testOffset() {
		let query = Query().offset(offset: 5)
		assertJSON("{\"offset\":5}", query.query)
	}

	func testLimit() {
		let query = Query().limit(limit: 10)
		assertJSON("{\"limit\":10}", query.query)
	}

	func testSort() {
		let query = Query().sort(name: "title")
		XCTAssertEqual("{\"sort\":[{\"title\":\"asc\"}]}", query.description)

		_ = query.sort(name: "author", order: Query.Order.DESC)

		assertJSON(
			"{\"sort\":[{\"title\":\"asc\"},{\"author\":\"desc\"}]}",
			query.query)
	}

	func testType_Count() {
		let query = Query().count()
		assertJSON("{\"type\":\"count\"}", query.query)
	}

	func testSearch_Query() {
		let query = Query()
		_ = query.search()

		_ = query.filter(field: "age", "=", 12)

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\"=\",\"value\":12}}], \"type\": \"search\"}",
			query.query)
	}

	func testFieldsQuery() {
		let query = Query().fields(fields: ["field1"])

		assertJSON(
			"{\"fields\":[\"field1\"]}",
			query.query)
	}

	func testMoreThanOneFieldsQuery() {
		let query = Query().fields(fields: ["field1", "field2", "field3"])

		assertJSON(
			"{\"fields\":[\"field1\", \"field2\", \"field3\"]}",
			query.query)
	}

}
