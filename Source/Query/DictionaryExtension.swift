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

internal extension Dictionary {

	var asJSON: String {
		let data = try! JSONSerialization.data(withJSONObject: self)
		return String(data: data, encoding: .utf8)!
	}

	var asQueryItems: [URLQueryItem] {
		var items = [URLQueryItem]()

		for (key, value) in self {
			if value is [AnyObject] || value is [String: AnyObject] {
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
