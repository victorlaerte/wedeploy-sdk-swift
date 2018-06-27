// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// WeDeployData+Filter


extension WeDeployData {

	public func any(field: String, value: [Any]) -> Self {
		return self.where(filter: Filter.any(field: field, value: value))
	}

	public func equal(field: String, value: Any) -> Self {
		return self.where(filter: Filter.equal(field: field, value: value))
	}

	public func gt(field: String, value: Any) -> Self {
		return self.where(filter: Filter.gt(field: field, value: value))
	}

	public func gte(field: String, value: Any) -> Self {
		return self.where(filter: Filter.gte(field: field, value: value))
	}

	public func lt(field: String, value: Any) -> Self {
		return self.where(filter: Filter.lt(field: field, value: value))
	}

	public func lte(field: String, value: Any) -> Self {
		return self.where(filter: Filter.lte(field: field, value: value))
	}

	public func none(field: String, value: [Any]) -> Self {
		return self.where(filter: Filter.none(field: field, value: value))
	}

	public func notEqual(field: String, value: Any) -> Self {
		return self.where(filter: Filter.notEqual(field: field, value: value))
	}

	public func regex(field: String, value: Any) -> Self {
		return self.where(filter: Filter.regex(field: field, value: value))
	}

	public func match(field: String, pattern: Any) -> Self {
		return self.where(filter: Filter.match(field: field, pattern: pattern))
	}

	public func similar(field: String, query: Any) -> Self {
		return self.where(filter: Filter.similar(field: field, query: query))
	}

	public func distance(field: String, latitude: Double, longitude: Double, range: Range) -> Self {
		return self.where(filter: Filter.distance(field: field, latitude: latitude, longitude: longitude, range: range))
	}

	public func distance(field: String, latitude: Double, longitude: Double, distance: DistanceUnit) -> Self {
		return self.where(filter: Filter.distance(field: field, latitude: latitude, longitude: longitude, distance: distance))
	}

	public func range(field: String, range: Range) -> Self {
		return self.where(filter: Filter.range(field: field, range: range))
	}

	public func polygon(field: String, points: [GeoPoint]) -> Self {
		return self.where(filter: Filter.polygon(field: field, points: points))
	}

	public func shape(field: String, shapes: [Geo]) -> Self {
		return self.where(filter: Filter.shape(field: field, shapes: shapes))
	}

	public func phrase(field: String, value: Any) -> Self {
		return self.where(filter: Filter.phrase(field: field, value: value))
	}

	public func prefix(field: String, value: Any) -> Self {
		return self.where(filter: Filter.prefix(field: field, value: value))
	}

	public func missing(field: String) -> Self {
		return self.where(filter: Filter.missing(field: field))
	}

	public func exists(field: String) -> Self {
		return self.where(filter: Filter.exists(field: field))
	}

	public func fuzzy(field: String, query: Any, fuzziness: Int) -> Self {
		return self.where(filter: Filter.fuzzy(field: field, query: query, fuzziness: fuzziness))
	}

	public func wildcard(field: String, value: String) -> Self {
		return self.where(filter: Filter.wildcard(field: field, value: value))
	}
}

