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


import WeDeploy
import XCTest

class QueryTest : XCTestCase {

	func testComplex_Query() {
		let query = Query()
			.filter(filter: Filter.gt("age", 12))
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
		let query = Query().filter(filter: Filter.gt("age", 12))

		assertJSON(
			"{\"filter\":[{\"age\":{\"operator\":\">\",\"value\":12}}]}",
			query.query)
	}

	func testFilter_With_Multiple_Filters() {
		let query = Query()
			.filter(filter: Filter.gt("age", 12))
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

		query.sort(name: "author", order: Query.Order.DESC)

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
		query.isSearch = true

		query.filter(field: "age", "=", 12)

		assertJSON(
			"{\"search\":[{\"age\":{\"operator\":\"=\",\"value\":12}}]}",
			query.query)
	}

}
