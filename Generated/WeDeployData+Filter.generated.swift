// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// WeDeployData+Filter


extension WeDeployData {

	/// Apply the filter Filter.any to the data query
	public func any(field: String, value: [Any]) -> Self {
		return self.where(filter: Filter.any(field: field, value: value))
	}

	/// Apply the filter Filter.equal to the data query
	public func equal(field: String, value: Any) -> Self {
		return self.where(filter: Filter.equal(field: field, value: value))
	}

	/// Apply the filter Filter.gt to the data query
	public func gt(field: String, value: Any) -> Self {
		return self.where(filter: Filter.gt(field: field, value: value))
	}

	/// Apply the filter Filter.gte to the data query
	public func gte(field: String, value: Any) -> Self {
		return self.where(filter: Filter.gte(field: field, value: value))
	}

	/// Apply the filter Filter.lt to the data query
	public func lt(field: String, value: Any) -> Self {
		return self.where(filter: Filter.lt(field: field, value: value))
	}

	/// Apply the filter Filter.lte to the data query
	public func lte(field: String, value: Any) -> Self {
		return self.where(filter: Filter.lte(field: field, value: value))
	}

	/// Apply the filter Filter.none to the data query
	public func none(field: String, value: [Any]) -> Self {
		return self.where(filter: Filter.none(field: field, value: value))
	}

	/// Apply the filter Filter.notEqual to the data query
	public func notEqual(field: String, value: Any) -> Self {
		return self.where(filter: Filter.notEqual(field: field, value: value))
	}

	/// Apply the filter Filter.regex to the data query
	public func regex(field: String, value: Any) -> Self {
		return self.where(filter: Filter.regex(field: field, value: value))
	}

	/// Apply the filter Filter.match to the data query
	public func match(field: String, pattern: Any) -> Self {
		return self.where(filter: Filter.match(field: field, pattern: pattern))
	}

	/// Apply the filter Filter.similar to the data query
	public func similar(field: String, query: Any) -> Self {
		return self.where(filter: Filter.similar(field: field, query: query))
	}

	/// Apply the filter Filter.distance to the data query
	public func distance(field: String, latitude: Double, longitude: Double, range: Range) -> Self {
		return self.where(filter: Filter.distance(field: field, latitude: latitude, longitude: longitude, range: range))
	}

	/// Apply the filter Filter.distance to the data query
	public func distance(field: String, latitude: Double, longitude: Double, distance: DistanceUnit) -> Self {
		return self.where(filter: Filter.distance(field: field, latitude: latitude, longitude: longitude, distance: distance))
	}

	/// Apply the filter Filter.range to the data query
	public func range(field: String, range: Range) -> Self {
		return self.where(filter: Filter.range(field: field, range: range))
	}

	/// Apply the filter Filter.polygon to the data query
	public func polygon(field: String, points: [GeoPoint]) -> Self {
		return self.where(filter: Filter.polygon(field: field, points: points))
	}

	/// Apply the filter Filter.shape to the data query
	public func shape(field: String, shapes: [Geo]) -> Self {
		return self.where(filter: Filter.shape(field: field, shapes: shapes))
	}

	/// Apply the filter Filter.phrase to the data query
	public func phrase(field: String, value: Any) -> Self {
		return self.where(filter: Filter.phrase(field: field, value: value))
	}

	/// Apply the filter Filter.prefix to the data query
	public func prefix(field: String, value: Any) -> Self {
		return self.where(filter: Filter.prefix(field: field, value: value))
	}

	/// Apply the filter Filter.missing to the data query
	public func missing(field: String) -> Self {
		return self.where(filter: Filter.missing(field: field))
	}

	/// Apply the filter Filter.exists to the data query
	public func exists(field: String) -> Self {
		return self.where(filter: Filter.exists(field: field))
	}

	/// Apply the filter Filter.fuzzy to the data query
	public func fuzzy(field: String, query: Any, fuzziness: Int) -> Self {
		return self.where(filter: Filter.fuzzy(field: field, query: query, fuzziness: fuzziness))
	}

	/// Apply the filter Filter.wildcard to the data query
	public func wildcard(field: String, value: String) -> Self {
		return self.where(filter: Filter.wildcard(field: field, value: value))
	}
}

