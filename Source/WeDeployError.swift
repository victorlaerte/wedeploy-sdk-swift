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

public struct WeDeployError: Error, CustomDebugStringConvertible {

	let code: Int
	let message: String

	let errors: [(reason: String, message: String)]

	public var debugDescription: String {
		let errorsString = errors.map { "reason: \($0) message: \($1)" }
		return "Code: \(code)\nmessage: \(message)\nErrors: \(errorsString)"
	}

	public static func errorFrom(response: Response?) -> WeDeployError {
		guard let body = response?.body as? [String: AnyObject],
			let code = response?.statusCode,
			let message = body["message"] as? String,
			let errorsArray = body["errors"] as? [AnyObject]
		else {
			return WeDeployError(
					code: response?.statusCode ?? -1,
					message: response?.body as? String ?? "No response body from the server",
					errors: [])
		}

		let errors = errorsArray
			.map { err -> (reason: String, message: String) in
				let errorDict = err as! [String: String]
				return (reason: errorDict["reason"] ?? "", message: errorDict["message"] ?? "")
			}

		return WeDeployError(code: Int(code), message: message, errors: errors)
	}
}

public enum WeDeployProviderError: Error {
	case noAccessToken
}

extension WeDeployProviderError: CustomStringConvertible {
	public var description: String {
		return "No access token found in the url"
	}
}
