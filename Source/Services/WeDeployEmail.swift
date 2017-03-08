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
import RxSwift

public class WeDeployEmail : WeDeployService {

	public func sendEmail(from: String, to: String, subject: String? = "", body: String) -> Promise<String> {
		return RequestBuilder
				.url(self.url)
				.path("/emails")
				.form(name: "from", value: from)
				.form(name: "to", value: to)
				.form(name: "subject", value: subject!)
				.form(name: "message", value: body)
				.authorize(auth: authorization)
				.post()
				.then { response in
					try response.validateBody(bodyType: String.self)
				}
	}

	public func checkEmailStatus(id: String) -> Promise<String> {
		return RequestBuilder
			.url(self.url)
			.path("/emails/\(id)/status")
			.authorize(auth: authorization)
			.get()
			.then { response in
				try response.validateBody(bodyType: String.self)
			}
	}

}
