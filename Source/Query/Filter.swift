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

/// Class responsible for building filters.
public class Filter: CustomStringConvertible, ExpressibleByStringLiteral {

	/// Component of the filter.
	public private(set) var filter = [String: AnyObject]()

	/// Filter in json form.
	public var description: String {
		return filter.asJSON
	}

	/// Creates a filter with the given expresion.
	/// Example: Filter("name = victor").
	public convenience init(_ expression: String) {
		var parts = expression.split {
			$0 == " "
		}.map(String.init)

		let field = parts[0]
		let op = parts[1]

		if let i = Int(parts[2]) {
			self.init(field: field, op: op, value: i)
		}
		else {
			self.init(field: field, op: op, value: parts[2])
		}
	}

	/// Creates an equal filter with the given field and value.
	public convenience init(_ field: String, _ value: Any) {
		self.init(field: field, op: "=", value: value)
	}

	/// Creates a filter.
	public init(field: String, op: String, value: Any?) {
		var newFilter: [String: Any] = [
			"operator": op
		]

		if let value = value {
			newFilter["value"] = value
		}

		filter[field] = newFilter as AnyObject
	}

	/// Creates an empty filter.
	public init() {}

	/// Creates a filter from a literal.
	public required convenience init(stringLiteral: StringLiteralType) {
		self.init(stringLiteral)
	}

	/// Composes all given filter with the and operator.
	public func and(filters: Filter...) -> Self {
		return self.and(filters)
	}

	/// Composes all given filter with the or operator.
	public func or(filters: Filter...) -> Self {
		return self.or(filters)
	}

	/// Create a filter with the any operator.
	/// This filter include entities that have a property field with any of the values in the value argument.
	public static func any(field: String, value: [Any]) -> Filter {
		return Filter(field: field, op: "any", value: value)
	}

	/// Create a filter with the equal operator.
	/// This filter include entities that have a property field with a value in the value argument.
	public static func equal(field: String, value: Any) -> Filter {
		return Filter(field, value)
	}

	/// Create a filter with the > operator.
	/// This filter include entities that have a property field with a value greater than the value argument.
	public static func gt(field: String, value: Any) -> Filter {
		return Filter(field: field, op: ">", value: value)
	}

	/// Create a filter with the >= operator.
	/// This filter include entities that have a property field with a value greater or equal than the value argument.
	public static func gte(field: String, value: Any) -> Filter {
		return Filter(field: field, op: ">=", value: value)
	}

	/// Create a filter with the < operator.
	/// This filter include entities that have a property field with a value lower than the value argument.
	public static func lt(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "<", value: value)
	}

	/// Create a filter with the <= operator.
	/// This filter include entities that have a property field with a value lower or equal than the value argument.
	public static func lte(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "<=", value: value)
	}

	/// Create a filter with the none operator.
	/// This filter include entities that have a property field with none of the values in the value argument.
	public static func none(field: String, value: [Any]) -> Filter {
		return Filter(field: field, op: "none", value: value)
	}

	/// Negates the filter.
	public func not() -> Filter {
		filter = [
			"not": filter as AnyObject
		]

		return self
	}

	/// Create a filter with the != operator.
	public static func notEqual(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "!=", value: value)
	}

	/// Create a filter with the regex operator.
	/// This filter include entities that have a property field with a value that matches the given regex.
	public static func regex(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "~", value: value)
	}

	/// Create a filter with the match operator.
	/// This filter include entities that have a property field with a value that matches the given pattern.
	public static func match(field: String, pattern: Any) -> Filter {
		return Filter(field: field, op: "match", value: pattern)
	}

	/// Create a filter with the similar operator.
	public static func similar(field: String, query: Any) -> Filter {
		return Filter(field: field, op: "similar", value: ["query": query])
	}

	/// Create a filter with the distance operator.
	/// This filter include entities that have a property field with a value in range of the given coordinates.
	public static func distance(field: String, latitude: Double,
			longitude: Double, range: Range) -> Filter {

		var value: [String: Any] = [
			"location": [latitude, longitude]
		]

		if let min = range.from {
			value["min"] = min
		}
		if let max = range.to {
			value["max"] = max
		}

		return Filter(field: field, op: "gd", value: value)
	}

	/// Create a filter with the distance operator.
	/// This filter include entities that have a property field with a value in range of the given coordinates.
	public static func distance(field: String, latitude: Double,
			longitude: Double, distance: DistanceUnit) -> Filter {

		return Filter.distance(field: field, latitude: latitude,
			longitude: longitude, range: Range(to: distance.value))
	}

	/// Create a filter with the range operator.
	/// This filter include entities that have a property field with a value in range between the given values.
	public static func range(field: String, range: Range) -> Filter {
		return Filter(field: field, op: "range", value: range.value)
	}

	/// Create a filter with the gp operator.
	/// This filter include entities that have a property field with a value that is inside in the geo
	/// polygon represented by the points passed.
	public static func polygon(field: String, points: [GeoPoint]) -> Filter {
		return Filter(field: field, op: "gp", value: points.map({ $0.value}))
	}

	/// Create a filter with the gs operator.
	/// This filter include entities that have a property field with a value that is inside in the geo
	/// polygon represented by the shapes passed.
	public static func shape(field: String, shapes: [Geo]) -> Filter {
		let value = [
			"type": "geometrycollection",
			"geometries": shapes.map({ $0.value })
		] as [String: Any]

		return Filter(field: field, op: "gs", value: value)
	}

	/// Create a filter with the phrase operator.
	public static func phrase(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "phrase", value: value)
	}

	/// Create a filter with the prefix operator.
	/// This filter include entities that have a property field with a value prefixed with the given value.
	public static func prefix(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "prefix", value: value)
	}

	/// Create a filter with the missing operator.
	/// This filter include entities that doesn't have the field passed.
	public static func missing(field: String) -> Filter {
		return Filter(field: field, op: "missing", value: nil)
	}

	/// Create a filter with the exists operator.
	/// This filter include entities that have the field passed.
	public static func exists(field: String) -> Filter {
		return Filter(field: field, op: "exists", value: nil)
	}

	/// Create a filter with the fuzzy operator.
	public static func fuzzy(field: String, query: Any, fuzziness: Int = 1) -> Filter {
		let value: [String: Any] = [
			"query": query,
			"fuzziness": fuzziness
		]
		return Filter(field: field, op: "fuzzy", value: value)
	}

	/// Create a filter with the wildcard operator.
	/// This filter include entities that have a property field with a value that matched the wildcard value given.
	public static func wildcard(field: String, value: String) -> Filter {
		return Filter(field: field, op: "wildcard", value: value)
	}


	/// Composes all given filter with the and operator.
	func and(_ filters: [Filter]) -> Self {
		let ands: [[String: AnyObject]]
		if self.filter.isEmpty {
			ands = filters.map({ $0.filter })
		}
		else {
			ands = (filter["and"] as? [[String: AnyObject]] ?? [self.filter]) + filters.map({ $0.filter })
		}

		filter = [
			"and": ands as AnyObject
		]

		return self
	}

	/// Composes all given filter with the or operator.
	func or(_ filters: [Filter]) -> Self {
		let ors: [[String: AnyObject]]
		if self.filter.isEmpty {
			ors = filters.map({ $0.filter })
		}
		else {
			ors = (filter["or"] as? [[String: AnyObject]] ?? [self.filter]) + filters.map({ $0.filter })
		}

		filter = [
			"or": ors as AnyObject
		]

		return self
	}

}

/// Compose two filters using the and operator
public func && (left: Filter, right: Filter) -> Filter {
	return left.and(filters: right)
}

/// Compose two filters using the or operator
public func || (left: Filter, right: Filter) -> Filter {
	return left.or(filters: right)
}

/// Negates a filter
public prefix func ! (filter: Filter) -> Filter {
	return filter.not()
}
