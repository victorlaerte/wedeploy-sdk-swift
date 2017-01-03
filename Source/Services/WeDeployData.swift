//
//  WeDeployData.swift
//  WeDeploy
//
//  Created by Victor Galán on 27/12/2016.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation
import later
import SocketIO


public class WeDeployData {

	var query = Query()
	var filter: Filter?

	let authorization: Auth?
	let url: String

	init(_ url: String, authorization: Auth? = nil) {
		self.url = url
		self.authorization = authorization
	}

	public func create(resource: String, object: [String : AnyObject]) -> Promise<[String : AnyObject]> {

		return doCreateRequest(resource: resource, object: object as AnyObject)
			.then {
				return self.castResponseAndReturnPromise(response: $0)
			}
	}

	public func create(resource: String, object: [[String : AnyObject]]) -> Promise<[[String : AnyObject]]> {

		return doCreateRequest(resource: resource, object: object as AnyObject)
			.then {
				return self.castResponseAndReturnPromise(response: $0)
			}
	}

	public func update(resourcePath: String, updatedAttributes: [String: AnyObject]) -> Promise<Void> {
		return RequestBuilder.url(self.url)
			.authorize(auth: self.authorization)
			.path("/\(resourcePath)")
			.patch()
			.then { response -> Promise<Void> in

				return Promise<Void> { fulfill, reject in
					if response.statusCode == 204 {
						fulfill(())
					}
					else {
						reject(WeDeployError.errorFrom(response: response))
					}
				}
			}
	}

	public func delete(collectionOrResourcePath: String) ->Promise<Response> {
		return RequestBuilder.url(self.url)
			.path("/\(collectionOrResourcePath)")
			.authorize(auth: self.authorization)
			.delete()
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
		filter = Filter.similar(field: field, value: pattern)
		return self
	}

	public func similar(field: String, query: String) -> Self {
		filter = Filter.similar(field: field, value: query)
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

	public func search(resourcePath: String) -> Promise<[String: AnyObject]> {
		query.isSearch = true
		return doGetRequest(resourcePath: resourcePath)
			.then {
				return self.castResponseAndReturnPromise(response: $0)
			}
	}

	public func get(resourcePath: String) -> Promise<[[String: AnyObject]]> {
		return doGetRequest(resourcePath: resourcePath)
			.then {
				return self.castResponseAndReturnPromise(response: $0)
			}
	}

	public func getCount(resourcePath: String) -> Promise<Int> {
		query = query.count()
		return doGetRequest(resourcePath: resourcePath)
			.then {
				return self.castResponseAndReturnPromise(response: $0)
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

	func doCreateRequest(resource: String, object: AnyObject) -> Promise<Response> {
		return RequestBuilder.url(self.url)
			.authorize(auth: self.authorization)
			.path("/\(resource)")
			.post(body: object)
	}

	func castResponseAndReturnPromise<T>(response: Response, type: T.Type? = T.self) -> Promise<T> {
		return Promise<T> { fulfill, reject in
			do {
				let body = try response.validateBody(bodyType: T.self)
				fulfill(body)
			} catch let error {
				reject(error)
			}
		}
	}
}
