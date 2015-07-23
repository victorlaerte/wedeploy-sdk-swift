import Foundation

public class Filter : Printable {

	public var filter = [String: [String: AnyObject]]()

	public var description: String {
		let data = NSJSONSerialization.dataWithJSONObject(
			filter, options: NSJSONWritingOptions.allZeros, error: nil)!

		return NSString(data: data,  encoding: NSUTF8StringEncoding)! as String
	}

	init(field: String, op: String = "=", value: AnyObject) {
		filter[field] = [
			"operator": op,
			"value": value
		]
	}

	public static func equal(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, value: value)
	}

	public static func gt(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, op: ">", value: value)
	}

	public static func gte(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, op: ">=", value: value)
	}

	public static func regex(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, op: "~", value: value)
	}

	public static func lt(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, op: "<", value: value)
	}

	public static func lte(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, op: "<=", value: value)
	}

	public static func notEqual(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, op: "!=", value: value)
	}

}