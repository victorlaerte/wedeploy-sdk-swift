//
//  WeDeployData.swift
//  WeDeploy
//
//  Created by Victor Galán on 27/12/2016.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation
import later


public class WeDeployData : RequestBuilder {

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

	func doCreateRequest(resource: String, object: AnyObject) -> Promise<Response> {
		return RequestBuilder.url(self._url)
			.authorize(auth: self.authorization)
			.path("/\(resource)")
			.post(body: object)
	}

}
