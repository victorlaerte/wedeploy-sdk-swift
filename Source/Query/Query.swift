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

public class Query : CustomStringConvertible {

	public private(set) var query = [String: Any]()

	public enum Order: String {
		case ASC = "asc", DESC = "desc"
	}

	public var description: String {
		return query.asJSON
	}

	public init() {}

	public func filter(field: String, _ value: Any) -> Self {
		return self.filter(filter: Filter(field, value))
	}

	public func filter(field: String, _ op: String, _ value: Any)
		-> Self {

		return self.filter(filter: Filter(field: field, op: op, value: value))
	}

	public func filter(filter: Filter) -> Self {
		var filters = query["filter"] as? [[String: AnyObject]] ??
			[[String: AnyObject]]()

		filters.append(filter.filter)

		query["filter"] = filters
		
		return self
	}

	public func aggregate(aggregation: Aggregation) -> Self {
		var aggregations = query["aggregation"] as? [[String: AnyObject]] ?? [[String: AnyObject]]()

		aggregations.append(aggregation.aggregation)

		query["aggregation"] = aggregations

		return self
	}

	public func highlight(fields: [String]) -> Self {
		var highlights = query["highlight"] as? [String] ?? [String]()

		highlights.append(contentsOf: fields)

		query["highlight"] = highlights

		return self
	}

	public func limit(limit: Int) -> Self {
		query["limit"] = limit
		return self
	}

	public func offset(offset: Int) -> Self {
		query["offset"] = offset
		return self
	}

	public func sort(name: String, order: Order = .ASC) -> Self {
		var sort = query["sort"] as? [[String: String]] ?? [[String: String]]()
		sort.append([name: order.rawValue])

		query["sort"] = sort
		return self
	}

	public func count() -> Self {
		query["type"] = "count"
		return self
	}
	
	public func search() -> Self {
		query["type"] = "search"
		return self
	}

}
