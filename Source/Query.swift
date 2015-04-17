import Foundation

public class Query : Printable {

	var query = [String: AnyObject]()

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

	func queryItems() -> [NSURLQueryItem] {
		var items = [NSURLQueryItem]()

		for (name, value) in query {
			items.append(NSURLQueryItem(name: name, value: value.description))
		}

		return items
	}

}