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
import PromiseKit
import SocketIO

public class WeDeployData: WeDeployService {

	var query = Query()
	var filter: Filter?

	public override func authorize(auth: Auth?) -> WeDeployData {
		return super.authorize(auth: auth) as! WeDeployData
	}

	public override func header(name: String, value: String) -> WeDeployData {
		return super.header(name: name, value: value) as! WeDeployData
	}

	public func create(resource: String, object: [String : Any]) -> Promise<[String : AnyObject]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validate()
			}
	}

	public func create(resource: String, object: [[String : Any]]) -> Promise<[String : AnyObject]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validateBody(bodyType: [String: AnyObject].self)
			}
	}

	public func update(resourcePath: String, updatedAttributes: [String: Any]) -> Promise<Void> {
		return requestBuilder
			.path("/\(resourcePath)")
			.patch(body: updatedAttributes)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	public func replace(resourcePath: String, replacedAttributes: [String: Any]) -> Promise<Void> {
		return requestBuilder
			.path("/\(resourcePath)")
			.put(body: replacedAttributes)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	public func delete(collectionOrResourcePath: String) ->Promise<Response> {
		return requestBuilder
			.path("/\(collectionOrResourcePath)")
			.delete()
	}

	public func filter(filter: Filter) -> Self {
		self.filter = filter
		return self
	}

	public func query(query: Query) -> Self {
		self.query = query
		return self
	}

	public func `where`(field: String, op: String, value: Any) -> Self {
		filter = getOrCreateFilter().and(Filter(field: field, op: op, value: value))
		return self
	}

	public func `where`(filter: Filter) -> Self {
		self.filter = getOrCreateFilter().and(filter)
		return self
	}

	public func or(field: String, op: String, value: Any) -> Self {
		filter = getOrCreateFilter().or(Filter(field: field, op: op, value: value))
		return self
	}

	public func none(field: String, value: [Any]) -> Self {
		return self.where(filter: Filter.none(field, value))
	}

	public func lt(field: String, value: Any) -> Self {
		return self.where(filter: Filter.lt(field, value))
	}

	public func lte(field: String, value: Any) -> Self {
		return self.where(filter: Filter.lte(field, value))
	}

	public func gt(field: String, value: Any) -> Self {
		return self.where(filter: Filter.gt(field, value))
	}

	public func gte(field: String, value: Any) -> Self {
		return self.where(filter: Filter.gt(field, value))
	}

	public func equal(field: String, value: Any) -> Self {
		return self.where(filter: Filter.equal(field, value))
	}

	public func any(field: String, value: [Any]) -> Self {
		return self.where(filter: Filter.any(field, value))
	}

	public func match(field: String, pattern: String) -> Self {
		return self.where(filter: Filter.match(field: field, value: pattern))
	}

	public func similar(field: String, query: String) -> Self {
		return self.where(filter: Filter.similar(field: field, query: query))
	}

	public func distance(field: String, latitude: Double,
		longitude: Double, range: Range) -> Self {

		return self.where(filter: Filter.distance(field: field,
				latitude: latitude, longitude: longitude, range: range))
	}

	public func distance(field: String, latitude: Double, longitude: Double,
		distance: DistanceUnit) -> Self {

		return self.where(filter: Filter.distance(field: field,
			latitude: latitude, longitude: longitude, distance: distance))
	}

	public func fuzzy(field: String, query: Any, fuzziness: Int = 0) -> Self {
		return self.where(filter: Filter.fuzzy(field: field, query: query, fuzziness: fuzziness))
	}

	public func range(field: String, range: Range) -> Self {
		return self.where(filter: Filter.range(field: field, range: range))
	}

	public  func polygon(field: String, points: [GeoPoint]) -> Self {
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

	public func orderBy(field: String, order: Query.Order) -> Self {
		query = query.sort(name: field, order: order)
		return self
	}

	public func limit(_ limit: Int) -> Self {
		query = query.limit(limit: limit)
		return self
	}

	public func offset(_ offset: Int) -> Self {
		query = query.offset(offset: offset)
		return self
	}

	public func count() -> Self {
		query = query.count()
		return self
	}

	public func aggregate(name: String, field: String, op: String, value: Any? = nil) -> Self {
		let aggregation = Aggregation(name: name, field: field, op: op, value: value)
		query = query.aggregate(aggregation: aggregation)
		return self
	}

	public func aggregate(aggregation: Aggregation) -> Self {
		query = query.aggregate(aggregation: aggregation)
		return self
	}

	public func highlight(_ fields: String...) -> Self {
		query = query.highlight(fields: fields)
		return self
	}

	public func search(resourcePath: String) -> Promise<[String: AnyObject]> {
		query = query.search()
		return doGetRequest(resourcePath: resourcePath)
			.then { response in
				try response.validate()
			}
	}

	public func get(resourcePath: String) -> Promise<[[String: AnyObject]]> {
		return get(resourcePath: resourcePath, type: [[String: AnyObject]].self)
	}

	public func get<T>(resourcePath: String, type: T.Type = T.self) -> Promise<T> {
		return doGetRequest(resourcePath: resourcePath)
			.then { response in
				try response.validateBody(bodyType: T.self)
			}
	}

	public func watch(resourcePath: String) -> SocketIOClient {
		if let filter = filter {
			query = query.filter(filter: filter)
		}

		let url = "\(self.url)/\(resourcePath)"
		var options = SocketIOClientConfiguration()

		let socket = SocketIOClientFactory.create(url: url, params: query.query.asQueryItems,
				auth: authorization, options: &options)

		query = Query()
		filter = nil

		return socket
	}

	func doGetRequest(resourcePath: String) -> Promise<Response> {
		if let filter = filter {
			query = query.filter(filter: filter)
		}

		let request = requestBuilder

		if query.query.count != 0 {
			request.params =  query.query.asQueryItems
		}

		query = Query()
		filter = nil

		return request.path("/\(resourcePath)")
			.get()
	}

	func getOrCreateFilter() -> Filter {
		if let filter = filter {
			return filter
		}

		return Filter()
	}

	func doCreateRequest(resource: String, object: Any) -> Promise<Response> {
		return requestBuilder.path("/\(resource)")
			.post(body: object)
	}
}
