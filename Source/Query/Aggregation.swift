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

/// Class responsible for building aggregations
public class Aggregation: CustomStringConvertible {

	/// Component of the aggregation.
	public var aggregation: [String: AnyObject]

	/// Aggregation in json form
	public var description: String {
		return aggregation.asJSON
	}

	/// Creates a new custom aggregation For creating standard aggregation you should use the convenience
	/// function like `Aggrigation.avg, Aggregation.count`, etc.
	public init(name: String, field: String, op: String, value: Any? = nil) {
		var innerDict: [String: Any] = [
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

	@discardableResult
	public func add(nestedAggregations: Aggregation...) -> Aggregation {
		let (field, aggregation) = self.aggregation.first!
		var aggregationMap = aggregation as! [String: Any]
		let currentNested = aggregation["aggregation"] as? [[String: AnyObject]] ?? []

		aggregationMap["aggregation"] = currentNested + nestedAggregations.map { $0.aggregation } as AnyObject

		self.aggregation[field] = aggregationMap as AnyObject

		return self
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

	public static func cardinality(name: String, field: String) -> Aggregation {
		return Aggregation(name: name, field: field, op: "cardinality")
	}

	public static func histogram(name: String, field: String, interval: TimeInterval) -> Aggregation {
		return Aggregation(name: name, field: field, op: "date_histogram", value: interval.rawValue)
	}

	public static func histogram(name: String, field: String, timeUnit: TimeUnit) -> Aggregation {
		return Aggregation(name: name, field: field, op: "date_histogram", value: timeUnit.rawValue)
	}

	public static func script(name: String, path: String, script: String) -> Aggregation {
		return Aggregation(name: name, field: path, op: "script", value: script)
	}

	public static func script(name: String, path: [String], script: String) -> Aggregation {
		return Aggregation(name: name, field: path.joined(separator: ","), op: "script", value: script)
	}
}
