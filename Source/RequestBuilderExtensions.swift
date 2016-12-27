//
//  RequestBuilderExtensions.swift
//  WeDeploy
//
//  Created by Victor Galán on 27/12/2016.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation
import later


extension RequestBuilder {

	func castResponseAndReturnPromise<T>(response: Response, type: T.Type) -> Promise<T> {
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
