import Foundation

public class Filter : Printable {

	public var filter = [String: AnyObject]()

	public var description: String {
		let data = NSJSONSerialization.dataWithJSONObject(
			filter, options: NSJSONWritingOptions.allZeros, error: nil)!

		return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
	}

	convenience init(_ field: String, _ value: AnyObject) {
		self.init(field, "=", value)
	}

	init(_ field: String, _ op: String, _ value: AnyObject) {
		filter[field] = [
			"operator": op,
			"value": value
		]
	}

	public func and(filters: Filter ...) -> Self {
		var and = filter["and"] as? [[String: AnyObject]] ?? [self.filter]

		filter = [
			"and": and + filters.map({ $0.filter })
		]

		return self
	}

	public func and(tuples: (String, String, AnyObject) ...) -> Self {
		var and = filter["and"] as? [[String: AnyObject]] ?? [self.filter]

		filter = [
			"and": and + tuples.map({ Filter($0.0, $0.1, $0.2).filter })
		]

		return self
	}

	public static func any(field: String, _ value: [AnyObject]) -> Filter {
		return Filter(field, "in", value)
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
		return Filter(field, "nin", value)
	}

	public static func notEqual(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "!=", value)
	}

	public static func regex(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "~", value)
	}

}