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

class FilterTest: XCTestCase {

	func testAnd() {
		let filter = Filter
			.gt("age", 12)
			.and(Filter.lt("age", 15))

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.filter)
	}

	func testAnd_WithOneFilter() {
		let filter = Filter().and(Filter.gt("age", 12))

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
			"]}",
			filter.filter)
	}

	func testAnd_Overloaded_Operator() {
		let filter = Filter
			.gt("age", 12) &&
			Filter.lt("age", 15) &&
			"name = foo"

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testAnd_With_Three_Filters() {
		let filter = Filter
			.gt("age", 12)
			.and(Filter.lt("age", 15))
			.and(Filter.equal("name", "foo"))

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testAny() {
		let filter = Filter.any("age", [12, 21, 25])

		assertJSON(
			"{\"age\":{\"operator\":\"any\",\"value\":[12,21,25]}}",
			filter.filter)
	}

	func testComposition() {
		let filter = Filter
			.gt("age", 12)
			.or("age < 15" as Filter)
			.and(Filter("name = foo"))

		print(filter.filter)

		assertJSON(
			"{\"and\":[" +
				"{\"or\":[" +
					"{\"age\":{\"operator\":\">\",\"value\":12}}," +
					"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
				"]}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testCustom() {
		let filter = Filter(field: "age", op: ">", value: 12)
		assertJSON("{\"age\":{\"operator\":\">\",\"value\":12}}", filter.filter)
	}

	func testDefaultOperator() {
		let filter = Filter("age", 12)
		assertJSON("{\"age\":{\"operator\":\"=\",\"value\":12}}", filter.filter)
	}

	func testEqual() {
		let filter = Filter.equal("age", 12)
		assertJSON("{\"age\":{\"operator\":\"=\",\"value\":12}}", filter.filter)
	}

	func testGt() {
		let filter = Filter.gt("age", 12)
		assertJSON("{\"age\":{\"operator\":\">\",\"value\":12}}", filter.filter)
	}

	func testGte() {
		let filter = Filter.gte("age", 12)
		assertJSON(
			"{\"age\":{\"operator\":\">=\",\"value\":12}}", filter.filter)
	}

	func testLt() {
		let filter = Filter.lt("age", 12)
		assertJSON("{\"age\":{\"operator\":\"<\",\"value\":12}}", filter.filter)
	}

	func testLte() {
		let filter = Filter.lte("age", 12)

		assertJSON(
			"{\"age\":{\"operator\":\"<=\",\"value\":12}}",
			filter.filter)
	}

	func testNone() {
		let filter = Filter.none("age", [12, 21, 25])

		assertJSON(
			"{\"age\":{\"operator\":\"none\",\"value\":[12,21,25]}}",
			filter.filter)
	}

	func testNot() {
		let filter = Filter("age", 12).not()

		assertJSON(
			"{\"not\":{\"age\":{\"operator\":\"=\",\"value\":12}}}",
			filter.filter)
	}

	func testNot_With_Operation() {
		let filter = !Filter("age", 12)

		assertJSON(
			"{\"not\":{\"age\":{\"operator\":\"=\",\"value\":12}}}",
			filter.filter)
	}

	func testNotEqual() {
		let filter = Filter.notEqual("age", 12)

		assertJSON(
			"{\"age\":{\"operator\":\"!=\",\"value\":12}}", filter.filter)
	}

	func testOr() {
		let filter = Filter
			.gt("age", 12)
			.or(Filter.lt("age", 15))

		assertJSON(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.filter)
	}

	func testOr_WithOneFilter() {
		let filter = Filter()
			.or(Filter.lt("age", 15))

		assertJSON(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.filter)
	}

	func testOr_Overloaded_Operator() {
		let filter = Filter
			.gt("age", 12) ||
			Filter.lt("age", 15) ||
			"name = foo"

		assertJSON(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testOr_With_Three_Filters() {
		let filter = Filter
			.gt("age", 12)
			.or(Filter.lt("age", 15))
			.or(Filter.equal("name", "foo"))

		assertJSON(
			"{\"or\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}," +
				"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}" +
			"]}",
			filter.filter)
	}

	func testRegex() {
		let filter = Filter.regex("age", 12)
		assertJSON("{\"age\":{\"operator\":\"~\",\"value\":12}}", filter.filter)
	}

	func testDistance() {
		let filter = Filter.distance(field: "point", latitude: 0, longitude: 0, range: Range(from: 0, to: 2))

		assertJSON("{\"point\":{\"operator\":\"gd\",\"value\":" +
		 "{\"location\": [0, 0], \"min\": 0, \"max\": 2}" +
		"}}", filter.filter)
	}

	func testDistanceWithoutMin() {
		let filter = Filter.distance(field: "point", latitude: 0, longitude: 0, range: Range(to: 2))

		assertJSON("{\"point\":{\"operator\":\"gd\",\"value\":" +
		 "{\"location\": [0, 0], \"max\": 2}" +
			"}}", filter.filter)
	}

	func testRange() {
		let filter = Filter.range(field: "age", range: Range(from: 10, to: 40))

		assertJSON("{\"age\":{\"operator\":\"range\",\"value\":" +
		 		"{\"from\": 10, \"to\": 40}" +
		"}}", filter.filter)
	}

	func testStringConvertible() {
		let filter: Filter = "age > 12"

		assertJSON("{\"age\":{\"operator\":\">\",\"value\":12}}", filter.filter)
	}

	func testStringConvertible_With_And_Operator() {
		let filter = Filter
			.gt("age", 12) &&
			"age < 15"

		assertJSON(
			"{\"and\":[" +
				"{\"age\":{\"operator\":\">\",\"value\":12}}," +
				"{\"age\":{\"operator\":\"<\",\"value\":15}}" +
			"]}",
			filter.filter)
	}

	func testStringConvertible_With_String_Value() {
		let filter: Filter = "name = foo"

		assertJSON(
			"{\"name\":{\"operator\":\"=\",\"value\":\"foo\"}}", filter.filter)
	}

	func testSimilarOperator() {
		let filter = Filter.similar(field: "age", query: 12)

		assertJSON("{\"age\":{\"operator\":\"similar\",\"value\":{\"query\":12}}}", filter.filter)
	}

	func testMatchOperator() {
		let filter = Filter.match(field: "age", value: 12)

		assertJSON("{\"age\":{\"operator\":\"match\",\"value\":12}}", filter.filter)
	}

	func testPolygonOperator() {
		let filter = Filter.polygon(field: "shape",
				points: [GeoPoint(lat: 10, long: 10), GeoPoint(lat: 20, long:30.5)])

		assertJSON("{\"shape\":{\"operator\":\"gp\",\"value\":[\"10.0,10.0\",\"20.0,30.5\"]}}", filter.filter)
	}

	func testShapeOperator_WithOneShape() {
		let filter = Filter.shape(field: "shape", shapes: [Circle(center: GeoPoint(lat: 0, long: 0), radius: 20)])

		assertJSON("{\"shape\":{\"operator\":\"gs\",\"value\":" +
						"{\"type\": \"geometrycollection\",\"geometries\":" +
								"[{\"coordinates\": \"0.0,0.0\", \"radius\": 20, \"type\": \"circle\"}]" +
						"}}" +
					"}", filter.filter)
	}

	func testShapeOperator_WithSeveralShapes() {
		let filter = Filter.shape(field: "shape", shapes:[
			Circle(center: GeoPoint(lat: 0, long: 0), radius: 20),
			BoundingBox(upperLeft: GeoPoint(lat:20.0, long:0.0), lowerRight: GeoPoint(lat: 0.0, long: 20.0))])

		assertJSON("{\"shape\":{\"operator\":\"gs\",\"value\":" +
						"{\"type\": \"geometrycollection\",\"geometries\":" +
							"[" +
								"{\"coordinates\": \"0.0,0.0\", \"radius\": 20, \"type\": \"circle\"}," +
								"{\"type\": \"envelope\",\"coordinates\": [\"20.0,0.0\",\"0.0,20.0\"]}" +
							"]" +
						"}}" +
					"}", filter.filter)
	}

}
