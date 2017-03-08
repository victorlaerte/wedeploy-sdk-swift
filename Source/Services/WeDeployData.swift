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


public class WeDeployData : WeDeployService {

	var query = Query()
	var filter: Filter?

	public func create(resource: String, object: [String : Any]) -> Promise<[String : AnyObject]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validate()
			}
	}

	public func create(resource: String, object: [[String : Any]]) -> Promise<[[String : AnyObject]]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validateBody(bodyType: [[String : AnyObject]].self)
			}
	}

	public func update(resourcePath: String, updatedAttributes: [String: Any]) -> Promise<Void> {
		return RequestBuilder.url(self.url)
			.authorize(auth: self.authorization)
			.path("/\(resourcePath)")
			.patch()
			.then { response in
				try response.validateEmptyBody()
			}
	}

	public func delete(collectionOrResourcePath: String) ->Promise<Response> {
		return RequestBuilder.url(self.url)
			.path("/\(collectionOrResourcePath)")
			.authorize(auth: self.authorization)
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

	public func `where`<T>(field: String, op: String, value: T) -> Self {
		filter = Filter(field: field, op: op, value: value)
		return self
	}

	public func or<T>(field: String, op: String, value: T) -> Self {
		filter = filter?.or(Filter(field: field, op: op, value: value))
		return self
	}

	public func none<T>(field: String, value: [T]) -> Self {
		filter = self.getOrCreateFilter().and(Filter.none(field, value))
		return self
	}

	public func lt<T>(field: String, value: T) -> Self {
		filter = self.getOrCreateFilter().and(Filter.lt(field, value))
		return self
	}

	public func lte<T>(field: String, value: T) -> Self {
		filter = self.getOrCreateFilter().and(Filter.lte(field, value))
		return self
	}

	public func gt<T>(field: String, value: T) -> Self {
		filter = self.getOrCreateFilter().and(Filter.gt(field, value))
		return self
	}

	public func gte<T>(field: String, value: T) -> Self {
		filter = self.getOrCreateFilter().and(Filter.gte(field, value))
		return self
	}

	public func equal<T>(field: String, value: T) -> Self {
		filter = self.getOrCreateFilter().and(Filter.equal(field, value))
		return self
	}

	public func any<T>(field: String, value: [T]) -> Self {
		filter = self.getOrCreateFilter().and(Filter.any(field, value))
		return self
	}

	public func match(field: String, pattern: String) -> Self {
		filter = Filter.match(field: field, value: pattern)
		return self
	}

	public func similar(field: String, query: String) -> Self {
		filter = Filter.similar(field: field, value: query)
		return self
	}

	public func distance(field: String, latitude: Double,
		longitude: Double, min: Int? = nil, max: Int? = nil) -> Self {

		filter = self.getOrCreateFilter()
				.and(Filter.distance(field: field, latitude: latitude, longitude: longitude, min: min, max: max))

		return self
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

	public func search(resourcePath: String) -> Promise<[String: AnyObject]> {
		query.isSearch = true
		return doGetRequest(resourcePath: resourcePath)
			.then { response in
				try response.validate()
			}
	}

	public func get(resourcePath: String) -> Promise<[[String: AnyObject]]>{
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

		let socket = SocketIOClientFactory.create(url: url, params: query.query.asQueryItems, options: &options)

		query = Query()
		filter = nil

		return socket
	}

	func doGetRequest(resourcePath: String) -> Promise<Response> {
		if let filter = filter {
			query = query.filter(filter: filter)
		}

		let request = RequestBuilder.url(self.url)

		if query.query.count != 0 {
			request.params =  query.query.asQueryItems
		}

		query = Query()
		filter = nil

		return request.authorize(auth: self.authorization)
			.path("/\(resourcePath)")
			.get()
	}

	func getOrCreateFilter() -> Filter {
		if let filter = filter {
			return filter
		}

		return Filter()
	}

	func doCreateRequest(resource: String, object: Any) -> Promise<Response> {
		return RequestBuilder.url(self.url)
			.authorize(auth: self.authorization)
			.path("/\(resource)")
			.post(body: object)
	}
}
