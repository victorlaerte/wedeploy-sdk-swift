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


public class WeDeployData : RequestBuilder {

	var query = Query()
	var filter: Filter?

	public init(url: String, authorization: Auth?) {
		super.init(url)

		self.authorization = authorization
	}

	public func create(resource: String, object: [String : AnyObject]) -> Promise<[String : AnyObject]> {

		return doCreateRequest(resource: resource, object: object as AnyObject)
			.then { response -> Promise<[String : AnyObject]> in

				return self.castResponseAndReturnPromise(response: response, type: [String : AnyObject].self)
			}
	}

	public func create(resource: String, object: [[String : AnyObject]]) -> Promise<[[String : AnyObject]]> {

		return doCreateRequest(resource: resource, object: object as AnyObject)
			.then { response -> Promise<[[String : AnyObject]]> in

				return self.castResponseAndReturnPromise(response: response, type: [[String : AnyObject]].self)
			}
	}

	public func update(resourcePath: String, updatedAttributes: [String: AnyObject]) -> Promise<Void> {
		return RequestBuilder.url(self._url)
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
		return RequestBuilder.url(self._url)
			.path("/\(collectionOrResourcePath)")
			.authorize(auth: self.authorization)
			.delete()
	}

	public func orderBy(field: String, order: Query.Order) -> Self {
		query.sort(name: field, order: order)
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

	public func match(field: String, pattern: String) -> Self {
		filter = Filter.similar(field: field, value: pattern)
		return self
	}

	public func similar(field: String, query: String) -> Self {
		filter = Filter.similar(field: field, value: query)
		return self
	}

	public func limit(_ limit: Int) -> Self {
		query.limit(limit: limit)
		return self
	}

	public func offset(_ offset: Int) -> Self {
		query.offset(offset: offset)
		return self
	}

	public func search(resourcePath: String) -> Promise<[String: AnyObject]> {
		query.isSearch = true
		return doGetRequest(resourcePath: resourcePath)
			.then { response -> Promise<[String : AnyObject]> in
				return self.castResponseAndReturnPromise(response: response, type: [String : AnyObject].self)
			}
	}

	public func get(resourcePath: String) -> Promise<[[String: AnyObject]]> {
		return doGetRequest(resourcePath: resourcePath)
			.then { response -> Promise<[[String : AnyObject]]> in
				return self.castResponseAndReturnPromise(response: response, type: [[String : AnyObject]].self)
			}
	}

	public func getCount(resourcePath: String) -> Promise<Int> {
		query.count()
		return doGetRequest(resourcePath: resourcePath)
			.then { response -> Promise<Int> in
				return self.castResponseAndReturnPromise(response: response, type: Int.self)
		}
	}

	public func watch(resourcePath: String) -> SocketIOClient {
		if let filter = filter {
			query.filter(filter: filter)
		}
		
		let url = "\(self._url)/\(resourcePath)"
		var options = SocketIOClientConfiguration()

		return SocketIOClientFactory.create(url: url, params: query.query.asQueryItems, options: &options)
	}

	public func doGetRequest(resourcePath: String) -> Promise<Response> {
		if let filter = filter {
			query.filter(filter: filter)
		}

		let request = RequestBuilder.url(self._url)

		if query.query.count != 0 {
			request.params =  query.query.asQueryItems
		}

		query = Query()
		filter = nil

		return request.authorize(auth: self.authorization)
			.path("/\(resourcePath)")
			.get()
	}

	func doCreateRequest(resource: String, object: AnyObject) -> Promise<Response> {
		return RequestBuilder.url(self._url)
			.authorize(auth: self.authorization)
			.path("/\(resource)")
			.post(body: object)
	}

}
