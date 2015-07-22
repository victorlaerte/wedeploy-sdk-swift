import Foundation

public class Query : Printable {

	var query = [String: AnyObject]()

	var params: [NSURLQueryItem] {
		var items = [NSURLQueryItem]()

		for (name, value) in query {
			var item: NSURLQueryItem

			if ((value is [AnyObject]) || (value is [String: AnyObject])) {
				let data = NSJSONSerialization.dataWithJSONObject(
					value, options: NSJSONWritingOptions.allZeros, error: nil)

				let json = NSString(data: data!, encoding: NSUTF8StringEncoding)

				item = NSURLQueryItem(name: name, value: json! as String)
			}
			else {
				item = NSURLQueryItem(name: name, value: value.description)
			}

			items.append(item)
		}

		return items
	}

	public enum Order: String {
		case ASC = "asc", DESC = "desc"
	}

	public var description: String {
		let data = NSJSONSerialization.dataWithJSONObject(
			query, options: NSJSONWritingOptions.allZeros, error: nil)!

		return NSString(data: data,  encoding: NSUTF8StringEncoding)! as String
	}

	public func count() -> Self {
		return type("count")
	}

	public func fetch() -> Self {
		return type("fetch")
	}

	public func filter(field: String, _ value: AnyObject)
		-> Self {

		return self.filter(Filter(field: field, value: value))
	}

	public func filter(field: String, _ op: String, _ value: AnyObject)
		-> Self {

		return self.filter(Filter(field: field, op: op, value: value))
	}

	public func filter(filter: Filter) -> Self {
		var filters = query["filter"] as? [[String: [String: AnyObject]]]

		if (filters == nil) {
			filters = [[String: [String: AnyObject]]]()
		}

		filters!.append(filter.filter)

		query["filter"] = filters

		return self
	}

	public func from(offset: Int) -> Self {
		query["offset"] = offset
		return self
	}

	public func limit(limit: Int) -> Self {
		query["limit"] = limit
		return self
	}

	public func scan() -> Self {
		return type("scan")
	}

	public func sort(name: String, order: Order = .ASC) -> Self {
		var sort = query["sort"] as? [[String: String]]

		if (sort == nil) {
			sort = [[String: String]]()
		}

		sort!.append([name: order.rawValue])
		query["sort"] = sort

		return self
	}

	public func type(type: String) -> Self {
		query["type"] = type

		return self
	}

}