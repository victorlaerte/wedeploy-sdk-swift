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
import PromiseKit
import SocketIO

/// Helper to communicate with Email service in WeDeploy.
public class WeDeployData: WeDeployService {

	var query = Query()
	var filter: Filter?

	/// Authorize the request with the given authentication.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public override func authorize(auth: Auth?) -> WeDeployData {
		return super.authorize(auth: auth) as! WeDeployData
	}

	/// Add a header to the request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public override func header(name: String, value: String) -> WeDeployData {
		return super.header(name: name, value: value) as! WeDeployData
	}

	/// Create a new resource.
	public func create(resource: String, object: [String: Any]) -> Promise<[String: AnyObject]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validate()
			}
	}

	/// Create a list of resources.
	public func create(resource: String, object: [[String: Any]]) -> Promise<[String: AnyObject]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validateBody(bodyType: [String: AnyObject].self)
			}
	}

	/// Update a resource with the attributes passed
	public func update(resourcePath: String, updatedAttributes: [String: Any]) -> Promise<Void> {
		return requestBuilder
			.path("/\(resourcePath)")
			.patch(body: updatedAttributes)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	/// Replace a resource's attributes with the attributes passed
	///
	/// - note: this will remove all the old attributes and add new ones
	public func replace(resourcePath: String, replacedAttributes: [String: Any]) -> Promise<Void> {
		return requestBuilder
			.path("/\(resourcePath)")
			.put(body: replacedAttributes)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	/// Delete a resource
	public func delete(collectionOrResourcePath: String) -> Promise<Response> {
		return requestBuilder
			.path("/\(collectionOrResourcePath)")
			.delete()
	}

	/// Create a new collection in the data service
	public func createCollection(name: String, fieldTypes: [String: CollectionFieldType]) -> Promise<[String: Any]> {
		let body: [String: Any] = [
			"mappings": fieldTypes.toJsonConvertible(),
			"name": name
		]

		return requestBuilder
			.post(body: body)
			.then { response in
				try response.validateBody(bodyType: [String: Any].self)
			}
	}

	/// Upadate a collection in the data service
	public func updateCollection(name: String, fieldTypes: [String: CollectionFieldType]) -> Promise<Void> {
		let body: [String: Any] = [
			"mappings": fieldTypes.toJsonConvertible(),
			"name": name
		]

		return requestBuilder
			.patch(body: body)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	/// Set a filter to the data request.
	/// - note: If you want a more fluent way to specify the filter, all the filter are
	/// 	available in the the form of convencience methods in this class
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func filter(filter: Filter) -> Self {
		self.filter = filter
		return self
	}

	/// Set a query to the data request.
	/// - note: If you want a more fluent way to specify the query, all the query methods are
	/// 	avaible in the the form of convencience methods in this class.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func query(query: Query) -> Self {
		self.query = query
		return self
	}

	/// Adds a filter to this request's query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func `where`(field: String, op: String, value: Any) -> Self {
		filter = getOrCreateFilter().and(filters: Filter(field: field, op: op, value: value))
		return self
	}

	/// Adds a filter to this request's query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func `where`(filter: Filter) -> Self {
		self.filter = getOrCreateFilter().and(filters: filter)
		return self
	}

	/// Adds a filter to be compose with this filter using the "or" operator.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func or(field: String, op: String, value: Any) -> Self {
		filter = getOrCreateFilter().or(filters: Filter(field: field, op: op, value: value))
		return self
	}

	// Adds a sort query to this request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func orderBy(field: String, order: Query.Order) -> Self {
		query = query.sort(name: field, order: order)
		return self
	}

	/// Sets the query to limit the elementes returned.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func limit(_ limit: Int) -> Self {
		query = query.limit(limit: limit)
		return self
	}

	/// Set the query to set an offset in the returned list.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func offset(_ offset: Int) -> Self {
		query = query.offset(offset: offset)
		return self
	}

	/// Set the query to return the count of the items that satisfied the filter.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func count() -> Self {
		query = query.count()
		return self
	}

	/// Adds an aggregation to the request's query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func aggregate(name: String, field: String, op: String, value: Any? = nil) -> Self {
		let aggregation = Aggregation(name: name, field: field, op: op, value: value)
		query = query.aggregate(aggregation: aggregation)
		return self
	}

	/// Adds an aggregation to the request's query.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func aggregate(aggregation: Aggregation) -> Self {
		query = query.aggregate(aggregation: aggregation)
		return self
	}

	/// Set a highlight query. Fields passed to this method will be hightlighted in the request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func highlight(_ fields: String...) -> Self {
		query = query.highlight(fields: fields)
		return self
	}

	/// Set a fields query. Use this method to select the fields of a resource
	/// that you want to receive from the server.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func fields(_ fields: String...) -> Self {
		query = query.fields(fields: fields)
		return self
	}

	/// Retrieve data from a [document/field/collection] and put it in a search format.
	public func search(resourcePath: String) -> Promise<[String: AnyObject]> {
		query = query.search()
		return doGetRequest(resourcePath: resourcePath)
			.then { response in
				try response.validate()
			}
	}

	/// Perform a get request to the path given.
	public func get(resourcePath: String) -> Promise<[[String: AnyObject]]> {
		return get(resourcePath: resourcePath, type: [[String: AnyObject]].self)
	}

	/// Perform a get request to the path given.
	///
	/// - parameter resoucercePath: path of the collection.
	/// - parameter type: type that will be used to cast the response to that type.
	public func get<T>(resourcePath: String, type: T.Type = T.self) -> Promise<T> {
		return doGetRequest(resourcePath: resourcePath)
			.then { response in
				try response.validateBody(bodyType: T.self)
			}
	}

	/// Creates a new realtime request.
	///
	/// - parameter resoucercePath: path of the collection.
	///
	/// - returnss: socket instance. Use this instane to start listening to eventss
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
