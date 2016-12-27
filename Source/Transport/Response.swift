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

public class Response {

	public private(set) var body: AnyObject?
	public let headers: [String: String]
	public let statusCode: Int

	public var contentType: String? {
		return headers["Content-Type"]
	}

	public var succeeded: Bool {
		return (statusCode >= 200) && (statusCode <= 399)
	}

	init(statusCode: Int, headers: [String: String], body: Data) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = parse(body: body)
	}

	func parse(body: Data) -> AnyObject? {
		if (contentType?.range(of: "application/json") != nil) {
			do {
				let parsed = try JSONSerialization.jsonObject(with: body, options: .allowFragments)

				return parsed as AnyObject
			}
			catch {
				return parseString(body: body) as AnyObject?
			}
		}
		else {
			return parseString(body: body) as AnyObject?
		}
	}

	func parseString(body: Data) -> String? {
		var string: String?

		if (body.count > 0) {
			string = String(data: body, encoding: .utf8)
		}

		return string
	}

	func validate() throws -> [String : AnyObject] {
		return try validateBody(bodyType: [String : AnyObject].self)
	}

	func validateBody<T>(bodyType: T.Type) throws -> T {
		guard 200 ..< 300 ~= statusCode,
			let body = body as? T
			else {
				throw WeDeployError.errorFrom(response: self)
		}

		return body
	}

}
