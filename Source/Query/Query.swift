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

	public private(set) var query = [String: AnyObject]()

	public enum QueryType: String {
		case COUNT = "count", FETCH = "fetch"
	}

	public enum Order: String {
		case ASC = "asc", DESC = "desc"
	}

	public var description: String {
		return query.asJSON
	}

	public init() {}

	public func count() -> Self {
		return type(.COUNT)
	}

	public func fetch() -> Self {
		return type(.FETCH)
	}

	public func filter(field: String, _ value: AnyObject) -> Self {
		return self.filter(filter: Filter(field, value))
	}

	public func filter(field: String, _ op: String, _ value: AnyObject)
		-> Self {

		return self.filter(filter: Filter(field, op, value))
	}

	public func filter(filter: Filter) -> Self {
		var filters = query["filter"] as? [[String: AnyObject]] ??
			[[String: AnyObject]]()

		filters.append(filter.filter)

		query["filter"] = filters as AnyObject
		return self
	}

	public func limit(limit: Int) -> Self {
		query["limit"] = limit as AnyObject
		return self
	}

	public func offset(offset: Int) -> Self {
		query["offset"] = offset as AnyObject
		return self
	}

	public func sort(name: String, order: Order = .ASC) -> Self {
		var sort = query["sort"] as? [[String: String]] ?? [[String: String]]()
		sort.append([name: order.rawValue])

		query["sort"] = sort as AnyObject
		return self
	}

	public func type(_ type: QueryType) -> Self {
		query["type"] = type.rawValue as AnyObject
		return self
	}

}
