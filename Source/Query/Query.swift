/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* 3. Neither the name of Liferay, Inc. nor the names of its contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation

/// Class responsible for building queries.
public class Query: CustomStringConvertible {

	/// Components of the query
	public private(set) var query = [String: Any]()

	/// Ordering modes
	public enum Order: String {
		case ASC = "asc", DESC = "desc"
	}

	/// query in json format
	public var description: String {
		return query.asJSON
	}

	public init() {}

	/// Adds a filter to this query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func filter(field: String, _ value: Any) -> Self {
		return self.filter(filter: Filter(field, value))
	}

	/// Adds a filter to this query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func filter(field: String, _ op: String, _ value: Any)
		-> Self {

		return self.filter(filter: Filter(field: field, op: op, value: value))
	}

	/// Adds a filter to this query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func filter(filter: Filter) -> Self {
		var filters = query["filter"] as? [[String: AnyObject]] ??
			[[String: AnyObject]]()

		filters.append(filter.filter)

		query["filter"] = filters

		return self
	}

	/// Adds an aggregation to this query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func aggregate(aggregation: Aggregation) -> Self {
		var aggregations = query["aggregation"] as? [[String: AnyObject]] ?? [[String: AnyObject]]()

		aggregations.append(aggregation.aggregation)

		query["aggregation"] = aggregations

		return self
	}

	/// Enable highlight. Fields passed to this method will be hightlighted in the request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func highlight(fields: [String]) -> Self {
		var highlights = query["highlight"] as? [String] ?? [String]()

		highlights.append(contentsOf: fields)

		query["highlight"] = highlights

		return self
	}

	/// Set the query limit.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func limit(limit: Int) -> Self {
		query["limit"] = limit
		return self
	}

	/// Set the query offset in the returned list.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func offset(offset: Int) -> Self {
		query["offset"] = offset
		return self
	}

	/// Set the query order.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func sort(name: String, order: Order = .ASC) -> Self {
		var sort = query["sort"] as? [[String: String]] ?? [[String: String]]()
		sort.append([name: order.rawValue])

		query["sort"] = sort
		return self
	}

	/// Set the query type to return the number of elements.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func count() -> Self {
		query["type"] = "count"
		return self
	}

	/// Set the query type to return the elements.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func search() -> Self {
		query["type"] = "search"
		return self
	}

	/// Set the query fields. The response will only contain this fields
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func fields(fields: [String]) -> Self {
		var currentFields = query["fields"] as? [String] ?? [String]()

		currentFields.append(contentsOf: fields)

		query["fields"] = currentFields

		return self
	}

}
