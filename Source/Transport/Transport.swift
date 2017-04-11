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

public protocol Transport {

	func send(
		request: Request, success: @escaping ((Response) -> Void), failure: @escaping (Error) -> Void)

}

public class NSURLSessionTransport: Transport {

	public func send(
		request: Request, success: @escaping ((Response) -> Void), failure: @escaping (Error) -> Void) {

		let success = dispatchMainThread(success)
		let failure = dispatchMainThread(failure)

		let config = URLSessionConfiguration.ephemeral
		let session = URLSession(configuration: config)

		do {
			let request = try request.toURLRequest()

			session.dataTask(with:
				request,
				completionHandler: { (data, r, error) in
					if let e = error {
						failure(e)
						return
					}

					let httpURLResponse = r as! HTTPURLResponse
					let headerFields = httpURLResponse.allHeaderFields
					var headers = [String: String]()

					for (key, value) in headerFields {
						headers[key.description] = value as? String
					}

					let response = Response(
						statusCode: httpURLResponse.statusCode,
						headers: headers, body: data!)

					success(response)
				}
			).resume()
		}
		catch let e as NSError {
			failure(e)
			return
		}
	}

	func dispatchMainThread<T>(_ block: @escaping (T) -> Void) -> (T) -> Void {
		return { value in

			DispatchQueue.main.async {
				block(value)
			}
		}
	}

}
