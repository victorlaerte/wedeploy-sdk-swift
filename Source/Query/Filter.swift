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

	public convenience init<T: CustomStringConvertible>(_ field: String, _ value: T) {
		self.init(field: field, op: "=", value: value)
	}

	public init<T: CustomStringConvertible>(field: String, op: String, value: T) {
		filter[field] = [
			"operator": op,
			"value": value
		] as AnyObject
	}

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

	public static func any<T: CustomStringConvertible>(_ field: String, _ value: [T]) -> Filter {
		return Filter(field: field, op: "any", value: value)
	}

	public static func equal<T: CustomStringConvertible>(_ field: String, _ value: T) -> Filter {
		return Filter(field, value)
	}

	public static func gt<T: CustomStringConvertible>(_ field: String, _ value: T) -> Filter {
		return Filter(field: field, op: ">", value: value)
	}

	public static func gte<T: CustomStringConvertible>(_ field: String, _ value: T) -> Filter {
		return Filter(field: field, op: ">=", value: value)
	}

	public static func lt<T: CustomStringConvertible>(_ field: String, _ value: T) -> Filter {
		return Filter(field: field, op: "<", value: value)
	}

	public static func lte<T: CustomStringConvertible>(_ field: String, _ value: T) -> Filter {
		return Filter(field: field, op: "<=", value: value)
	}

	public static func none<T: CustomStringConvertible>(_ field: String, _ value: [T]) -> Filter {
		return Filter(field: field, op: "none", value: value)
	}

	public func not() -> Filter {
		filter = [
			"not": filter as AnyObject
		]

		return self
	}

	public static func notEqual<T: CustomStringConvertible>(_ field: String, _ value: T) -> Filter {
		return Filter(field: field, op: "!=", value: value)
	}

	public func or(_ filters: Filter...) -> Self {
		return self.or(filters)
	}

	public static func regex<T: CustomStringConvertible>(_ field: String, _ value: T) -> Filter {
		return Filter(field: field, op: "~", value: value)
	}

	func and(_ filters: [Filter]) -> Self {
		let and = filter["and"] as? [[String: AnyObject]] ?? [self.filter]

		filter = [
			"and": and + filters.map({ $0.filter }) as AnyObject
		]

		return self
	}

	func or(_ filters: [Filter]) -> Self {
		let or = filter["or"] as? [[String: AnyObject]] ?? [self.filter]

		filter = [
			"or": or + filters.map({ $0.filter }) as AnyObject
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
