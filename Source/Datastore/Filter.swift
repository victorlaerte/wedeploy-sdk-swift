import Foundation

public class Filter : Printable {

	public var filter = [String: [String: AnyObject]]()

	public var description: String {
		let data = NSJSONSerialization.dataWithJSONObject(
			filter, options: NSJSONWritingOptions.allZeros, error: nil)!

		return NSString(data: data,  encoding: NSUTF8StringEncoding)! as String
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

	public static func equal(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, value)
	}

	public static func gt(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, ">", value)
	}

	public static func gte(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, ">=", value)
	}

	public static func regex(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "~", value)
	}

	public static func lt(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "<", value)
	}

	public static func lte(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "<=", value)
	}

	public static func notEqual(field: String, _ value: AnyObject) -> Filter {
		return Filter(field, "!=", value)
	}

}