//
//  WeDeployError.swift
//  Launchpad
//
//  Created by Victor Galán on 29/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation

public struct WeDeployError : Error, CustomDebugStringConvertible {

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
					message: response?.body?.description ?? "No response body from the server",
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
