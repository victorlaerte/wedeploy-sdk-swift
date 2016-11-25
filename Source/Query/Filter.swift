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

		var value: AnyObject = parts[2] as AnyObject

		if let i = Int(parts[2]) {
			value = i as AnyObject
		}

		self.init(parts[0], parts[1], value)
	}

	public convenience init(_ field: String, _ value: AnyObject) {
		self.init(field, "=", value)
	}

	public init(_ field: String, _ op: String, _ value: AnyObject) {
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

	public func and(filters: Filter...) -> Self {
		return self.and(filters: filters)
	}

	public static func any(field: String, _ value: [AnyObject]) -> Filter {
		return Filter(field, "any", value as AnyObject)
	}

	public static func equal(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, value)
	}

	public static func gt(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, ">", value)
	}

	public static func gte(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, ">=", value)
	}

	public static func lt(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "<", value)
	}

	public static func lte(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "<=", value)
	}

	public static func none(field: String, _ value: [AnyObject]) -> Filter {
		return Filter(field, "none", value as AnyObject)
	}

	public func not() -> Filter {
		filter = [
			"not": filter as AnyObject
		]

		return self
	}

	public static func notEqual(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "!=", value)
	}

	public func or(filters: Filter...) -> Self {
		return self.or(filters: filters)
	}

	public static func regex(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "~", value)
	}

	func and(filters: [Filter]) -> Self {
		let and = filter["and"] as? [[String: AnyObject]] ?? [self.filter]

		filter = [
			"and": and + filters.map({ $0.filter }) as AnyObject
		]

		return self
	}

	func or(filters: [Filter]) -> Self {
		let or = filter["or"] as? [[String: AnyObject]] ?? [self.filter]

		filter = [
			"or": or + filters.map({ $0.filter }) as AnyObject
		]

		return self
	}

}

public func &&(left: Filter, right: Filter) -> Filter {
	return left.and(filters: right)
}

public func ||(left: Filter, right: Filter) -> Filter {
	return left.or(filters: right)
}

public prefix func !(filter: Filter) -> Filter {
	return filter.not()
}
