import Foundation

public class Query : Printable {

	var query = [String: AnyObject]()

	public enum Order: String {
		case ASC = "asc", DESC = "desc"
	}

	public var description: String {
		let data = NSJSONSerialization.dataWithJSONObject(
			query, options: NSJSONWritingOptions.allZeros, error: nil)!

		return NSString(data: data,  encoding: NSUTF8StringEncoding)!
	}

	public func offset(offset: Int) -> Self {
		query["offset"] = offset
		return self
	}

	public func limit(limit: Int) -> Self {
		query["limit"] = limit
		return self
	}

	public func sort(name: String, order: Order = Order.ASC) -> Self {
		var sort = query["sort"] as? [[String: String]]

		if (sort == nil) {
			sort = [[String: String]]()
		}

		sort!.append([name: order.rawValue])
		query["sort"] = sort

		return self
	}

	func queryItems() -> [NSURLQueryItem] {
		var items = [NSURLQueryItem]()

		for (name, value) in query {
			var item: NSURLQueryItem

			if let v = value as? [String: AnyObject] {
				let data = NSJSONSerialization.dataWithJSONObject(
					v, options: NSJSONWritingOptions.allZeros, error: nil)

				let json = NSString(data: data!, encoding: NSUTF8StringEncoding)

				item = NSURLQueryItem(name: name, value: json!)
			}
			else {
				item = NSURLQueryItem(name: name, value: value.description)
			}

			items.append(item)
		}

		return items
	}

}