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

public class WeDeploy: RequestBuilder {

	override public class func url(_ url: String) -> WeDeploy {
		return WeDeploy(url)
	}

	public class func auth(_ url: String, authorization: Auth? = nil) -> WeDeployAuth {
		let url = validate(url: url)

		return WeDeployAuth(url, authorization: authorization)
	}

	public class func data(_ url: String, authorization: Auth? = nil) -> WeDeployData {
		let dataUrl = validate(url: url)

		return WeDeployData(dataUrl, authorization: authorization)
	}

	public class func email(_ url: String, authorization: Auth? = nil) -> WeDeployEmail {
		let emailUrl = validate(url: url)

		return WeDeployEmail(emailUrl, authorization: authorization)
	}

	class func validate(url: String) -> String {
		var finalUrl = url
		if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
			finalUrl = "http://" + finalUrl
		}

		if url.hasSuffix("/") {
			let slashIndex = finalUrl.index(finalUrl.endIndex, offsetBy: -1)
			finalUrl = finalUrl.substring(to: slashIndex)
		}

		return finalUrl
	}
}
