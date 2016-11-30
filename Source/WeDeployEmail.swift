//
//  WeDeployEmail.swift
//  Launchpad
//
//  Created by Victor Galán on 29/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation
import later
import RxSwift

public class WeDeployEmail : RequestBuilder {

	public func sendEmail(from: String, to: String, subject: String? = "", body: String) -> Promise<String> {

		return RequestBuilder
				.url(self._url)
				.path("/emails")
				.form(name: "from", value: from)
				.form(name: "to", value: to)
				.form(name: "subject", value: subject!)
				.form(name: "message", value: body)
				.authorize(auth: authorization)
				.post()
				.then { response -> Promise<String> in
					Promise<String> { fulfill, reject in
						if response.statusCode == 200 {
							fulfill(response.body!.description)
						}
						else {
							reject(WeDeployError.errorFrom(response: response))
						}
					}
				}
	}

}
