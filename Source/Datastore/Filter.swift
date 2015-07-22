import Foundation

public class Filter {

	public var filter = [String: [String: AnyObject]]()

	init(field: String, op: String = "=", value: AnyObject) {
		filter[field] = [
			"operator": op,
			"value": value
		]
	}

	public static func gt(field: String, _ value: AnyObject) -> Filter {
		return Filter(field: field, op: ">", value: value)
	}

}