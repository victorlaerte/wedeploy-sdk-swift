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


public class Aggregation : CustomStringConvertible {

	public let aggregation: [String: AnyObject]

	public var description: String {
		return aggregation.asJSON
	}

	public init(name: String, field: String, op: String, value: Any? = nil) {
		var innerDict: [String : Any] = [
			"name": name,
			"operator": op
		]

		if let value = value {
			innerDict["value"] = value
		}

		self.aggregation = [
			field: innerDict as AnyObject
		]
	}

	public static func avg(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "avg")
	}

	public static func count(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "count")
	}

	public static func extendedStats(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "extendedStats")
	}

	public static func max(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "max")
	}

	public static func min(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "min")
	}

	public static func missing(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "missing")
	}

	public static func stats(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "stats")
	}

	public static func sum(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "sum")
	}

	public static func terms(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "terms")
	}
}
