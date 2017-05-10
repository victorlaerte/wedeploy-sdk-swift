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

public class WeDeployEmail: WeDeployService {

	var params: [(name: String, value: String)] = []

	public func from(_ from: String) -> Self {
		params.append(("from", from))
		return self
	}

	public func to(_ to: String) -> Self {
		params.append(("to", to))
		return self
	}

	public func subject(_ subject: String) -> Self {
		params.append(("subject", subject))
		return self
	}

	public func message(_ message: String) -> Self {
		params.append(("message", message))
		return self
	}

	public func priority(_ priority: Int) -> Self {
		params.append(("priority", "\(priority)"))
		return self
	}

	public func replyTo(_ replyTo: String) -> Self {
		params.append(("replyTo", replyTo))
		return self
	}

	public func cc(_ cc: String) -> Self {
		params.append(("cc", cc))
		return self
	}

	public func bcc(_ bcc: String) -> Self {
		params.append(("bcc", bcc))
		return self
	}

	public func send() -> Promise<String> {
		var builder = RequestBuilder
				.url(self.url)
				.path("/emails")
				.authorize(auth: authorization)

		for param in params {
			builder = builder.form(name: param.name, value: param.value)
		}

		return builder
			.post().then { response in
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
