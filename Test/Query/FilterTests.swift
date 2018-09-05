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

class FilterTest: XCTestCase {

	func testAnd() {
		let filter = Filter
			.gt(field: "age", value: 12)
			.and(filters: Filter.lt(field: "age", value: 15))

		matchSnapshot(filter.filter)
	}

	func testAnd_WithOneFilter() {
		let filter = Filter().and(filters: Filter.gt(field: "age", value: 12))

		matchSnapshot(filter.filter)
	}

	func testAnd_Overloaded_Operator() {
		let filter = Filter
			.gt(field: "age", value: 12) &&
			Filter.lt(field: "age", value: 15) &&
			"name = foo"

		matchSnapshot(filter.filter)
	}

	func testAnd_With_Three_Filters() {
		let filter = Filter
			.gt(field: "age", value: 12)
			.and(filters: Filter.lt(field: "age", value: 15))
			.and(filters: Filter.equal(field: "name", value: "foo"))

		matchSnapshot(filter.filter)
	}

	func testAny() {
		let filter = Filter.any(field: "age", value: [12, 21, 25])

		matchSnapshot(filter.filter)
	}

	func testComposition() {
		let filter = Filter
			.gt(field: "age", value: 12)
			.or(filters: "age < 15" as Filter)
			.and(filters: Filter("name = foo"))

		print(filter.filter)

		matchSnapshot(filter.filter)
	}

	func testCustom() {
		let filter = Filter(field: "age", op: ">", value: 12)

		matchSnapshot(filter.filter)
	}

	func testDefaultOperator() {
		let filter = Filter("age", 12)

		matchSnapshot(filter.filter)
	}

	func testEqual() {
		let filter = Filter.equal(field: "age", value: 12)

		matchSnapshot(filter.filter)
	}

	func testGt() {
		let filter = Filter.gt(field: "age", value: 12)

		matchSnapshot(filter.filter)
	}

	func testGte() {
		let filter = Filter.gte(field: "age", value: 12)

		matchSnapshot(filter.filter)
	}

	func testLt() {
		let filter = Filter.lt(field: "age", value: 12)

		matchSnapshot(filter.filter)
	}

	func testLte() {
		let filter = Filter.lte(field: "age", value: 12)

		matchSnapshot(filter.filter)
	}

	func testNone() {
		let filter = Filter.none(field: "age", value: [12, 21, 25])

		matchSnapshot(filter.filter)
	}

	func testNot() {
		let filter = Filter("age", 12).not()

		matchSnapshot(filter.filter)
	}

	func testNot_With_Operation() {
		let filter = !Filter("age", 12)

		matchSnapshot(filter.filter)
	}

	func testNotEqual() {
		let filter = Filter.notEqual(field: "age", value: 12)

		matchSnapshot(filter.filter)
	}

	func testOr() {
		let filter = Filter
			.gt(field: "age", value: 12)
			.or(filters: Filter.lt(field: "age", value: 15))

		matchSnapshot(filter.filter)
	}

	func testOr_WithOneFilter() {
		let filter = Filter()
			.or(filters: Filter.lt(field: "age", value: 15))

		matchSnapshot(filter.filter)
	}

	func testOr_Overloaded_Operator() {
		let filter = Filter
			.gt(field: "age", value: 12) ||
			Filter.lt(field: "age", value: 15) ||
			"name = foo"

		matchSnapshot(filter.filter)
	}

	func testOr_With_Three_Filters() {
		let filter = Filter
			.gt(field: "age", value: 12)
			.or(filters: Filter.lt(field: "age", value: 15))
			.or(filters: Filter.equal(field: "name", value: "foo"))

		matchSnapshot(filter.filter)
	}

	func testRegex() {
		let filter = Filter.regex(field: "age", value: 12)

		matchSnapshot(filter.filter)
	}

	func testDistance() {
		let filter = Filter.distance(field: "point", latitude: 0, longitude: 0, range: Range(from: 0, to: 2))

		matchSnapshot(filter.filter)
	}

	func testDistanceWithoutMin() {
		let filter = Filter.distance(field: "point", latitude: 0, longitude: 0, range: Range(to: 2))

		matchSnapshot(filter.filter)
	}

	func testRange() {
		let filter = Filter.range(field: "age", range: Range(from: 10, to: 40))

		matchSnapshot(filter.filter)
	}

	func testStringConvertible() {
		let filter: Filter = "age > 12"

		matchSnapshot(filter.filter)
	}

	func testStringConvertible_With_And_Operator() {
		let filter = Filter
			.gt(field: "age", value: 12) &&
			"age < 15"

		matchSnapshot(filter.filter)
	}

	func testStringConvertible_With_String_Value() {
		let filter: Filter = "name = foo"

		matchSnapshot(filter.filter)
	}

	func testSimilarOperator() {
		let filter = Filter.similar(field: "age", query: 12)

		matchSnapshot(filter.filter)
	}

	func testMatchOperator() {
		let filter = Filter.match(field: "age", pattern: 12)

		matchSnapshot(filter.filter)
	}

	func testPolygonOperator() {
		let filter = Filter.polygon(field: "shape",
				points: [GeoPoint(lat: 10, long: 10), GeoPoint(lat: 20, long:30.5)])

		matchSnapshot(filter.filter)
	}

	func testShapeOperator_WithOneShape() {
		let filter = Filter.shape(field: "shape", shapes: [Circle(center: GeoPoint(lat: 0, long: 0), radius: 20)])

		matchSnapshot(filter.filter)
	}

	func testShapeOperator_WithSeveralShapes() {
		let filter = Filter.shape(field: "shape", shapes:[
			Circle(center: GeoPoint(lat: 0, long: 0), radius: 20),
			BoundingBox(upperLeft: GeoPoint(lat:20.0, long:0.0), lowerRight: GeoPoint(lat: 0.0, long: 20.0))])

		matchSnapshot(filter.filter)
	}

	func testPrefix() {
		let filter = Filter.prefix(field: "name", value: "an")

		matchSnapshot(filter.filter)
	}

	func testWildcard() {
		let filter = Filter.wildcard(field: "name", value: "an*")

		matchSnapshot(filter.filter)
	}

	func testMultiMatch() {
		let filter = Filter.multiMatch(fields: ["field1", "field2"], value: "value1")

		assertJSON("{\"field1,field2\":{\"operator\":\"multi_match\",\"value\":\"value1\"}}", filter.filter)
	}
}
