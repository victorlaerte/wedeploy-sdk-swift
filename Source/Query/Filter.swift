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

public typealias ExtendedGraphemeClusterLiteralType = String
public typealias UnicodeScalarLiteralType = String

public class Filter : CustomStringConvertible, ExpressibleByStringLiteral {

	public private(set) var filter = [String: AnyObject]()

	public var description: String {
		return filter.asJSON
	}

	public convenience init(_ expression: String) {
		var parts = expression.characters.split {
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

	public convenience init(_ field: String, _ value: Any) {
		self.init(field: field, op: "=", value: value)
	}

	public init(field: String, op: String, value: Any?) {
		var newFilter: [String: Any] = [
			"operator": op,
		]

		if let value = value {
			newFilter["value"] = value
		}

		filter[field] = newFilter as AnyObject
	}

	public init() {}

	public required convenience init(extendedGraphemeClusterLiteral: String) {
		self.init(extendedGraphemeClusterLiteral)
	}

	public required convenience init(stringLiteral: StringLiteralType) {
		self.init(stringLiteral)
	}

	public required convenience init(unicodeScalarLiteral: String) {
		self.init(unicodeScalarLiteral)
	}

	public func and(_ filters: Filter...) -> Self {
		return self.and(filters)
	}

	public static func any(_ field: String, _ value: [Any]) -> Filter {
		return Filter(field: field, op: "any", value: value)
	}

	public static func equal(_ field: String, _ value: Any) -> Filter {
		return Filter(field, value)
	}

	public static func gt(_ field: String, _ value: Any) -> Filter {
		return Filter(field: field, op: ">", value: value)
	}

	public static func gte(_ field: String, _ value: Any) -> Filter {
		return Filter(field: field, op: ">=", value: value)
	}

	public static func lt(_ field: String, _ value: Any) -> Filter {
		return Filter(field: field, op: "<", value: value)
	}

	public static func lte(_ field: String, _ value: Any) -> Filter {
		return Filter(field: field, op: "<=", value: value)
	}

	public static func none(_ field: String, _ value: [Any]) -> Filter {
		return Filter(field: field, op: "none", value: value)
	}

	public func not() -> Filter {
		filter = [
			"not": filter as AnyObject
		]

		return self
	}

	public static func notEqual(_ field: String, _ value: Any) -> Filter {
		return Filter(field: field, op: "!=", value: value)
	}

	public func or(_ filters: Filter...) -> Self {
		return self.or(filters)
	}

	public static func regex(_ field: String, _ value: Any) -> Filter {
		return Filter(field: field, op: "~", value: value)
	}

	public static func match(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "match", value: value)
	}

	public static func similar(field: String, query: Any) -> Filter {
		return Filter(field: field, op: "similar", value: ["query": query])
	}

	public static func distance(field: String, latitude: Double,
			longitude: Double, range: Range) -> Filter {
			
		var value: [String : Any] = [
			"location" : [latitude, longitude]
		]

		if let min = range.from {
			value["min"] = min
		}
		if let max = range.to {
			value["max"] = max
		}

		return Filter(field: field, op: "gd", value: value)
	}

	public static func range(field: String, range: Range) -> Filter {
		return Filter(field: field, op: "range", value: range.value)
	}

	public static func polygon(field: String, points: [GeoPoint]) -> Filter {
		return Filter(field: field, op: "gp", value: points.map({ $0.value}))
	}

	public static func shape(field: String, shapes: [Geo]) -> Filter {
		let value = [
			"type" : "geometrycollection",
			"geometries": shapes.map({ $0.value })
		] as [String : Any]
		
		return Filter(field: field, op: "gs", value: value)
	}

	public static func phrase(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "phrase", value: value)
	}

	public static func prefix(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "pre", value: value)
	}

	public static func missing(field: String) -> Filter {
		return Filter(field: field, op: "missing", value: nil)
	}

	public static func exists(field: String) -> Filter {
		return Filter(field: field, op: "exists", value: nil)
	}

	public static func fuzzy(field: String, query: Any, fuzziness: Int = 1) -> Filter {
		let value: [String : Any] = [
			"query": query,
			"fuzziness": fuzziness
		]
		return Filter(field: field, op: "fuzzy", value: value)
	}

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

public func &&(left: Filter, right: Filter) -> Filter {
	return left.and(right)
}

public func ||(left: Filter, right: Filter) -> Filter {
	return left.or(right)
}

public prefix func !(filter: Filter) -> Filter {
	return filter.not()
}
