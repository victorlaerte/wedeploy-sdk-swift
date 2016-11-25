import Foundation

internal extension Dictionary {

	var asJSON: String {
		let data = try! JSONSerialization.data(withJSONObject: self as AnyObject)

		return String(data: data, encoding: .utf8)!
	}

	var asQueryItems: [URLQueryItem] {
		var items = [URLQueryItem]()

		for (key, value) in self {
			if ((value is [AnyObject]) || (value is [String: AnyObject])) {
				let data = try! JSONSerialization.data(withJSONObject:
					value as AnyObject)

				let json = String(data: data, encoding: .utf8)

				items.append(
					URLQueryItem(name: "\(key)", value: json! as String))
			}
			else {
				items.append(URLQueryItem(name: "\(key)", value: "\(value)"))
			}
		}

		return items
	}

}
