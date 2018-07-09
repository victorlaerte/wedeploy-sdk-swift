/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* 3. Neither the name of Liferay, Inc. nor the names of its contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import PromiseKit
import RxSwift

/// Helper to communicate with Email service in WeDeploy.
/// You can create a message and send it in a fluent way:
///
/// ```
///	WeDeploy.email("auth-service-url")
///		.authorize(auth: TokenAuth(token: "someToken"))
///		.from("me@me.com")
///		.to("you@you.com")
///		.message("message")
///		.send()
/// ```
public class WeDeployEmail: WeDeployService {

	var params: [(name: String, value: String)] = []

	/// Authorize the request with the given authentication.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public override func authorize(auth: Auth?) -> WeDeployEmail {
		return super.authorize(auth: auth) as! WeDeployEmail
	}

	/// Add a header to the request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public override func header(name: String, value: String) -> WeDeployEmail {
		return super.header(name: name, value: value) as! WeDeployEmail
	}

	/// Set from attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func from(_ from: String) -> Self {
		params.append(("from", from))
		return self
	}

	/// Set to attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func to(_ to: String) -> Self {
		params.append(("to", to))
		return self
	}

	/// Set subject attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func subject(_ subject: String) -> Self {
		params.append(("subject", subject))
		return self
	}

	/// Set message attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func message(_ message: String) -> Self {
		params.append(("message", message))
		return self
	}

	/// Set priority attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func priority(_ priority: Int) -> Self {
		params.append(("priority", "\(priority)"))
		return self
	}

	/// Set replyTo attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func replyTo(_ replyTo: String) -> Self {
		params.append(("replyTo", replyTo))
		return self
	}

	/// Set cc attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func cc(_ cc: String) -> Self {
		params.append(("cc", cc))
		return self
	}

	/// Set bcc attribute on params to be sent on email request.
	///
	/// - returns: Return the object itself, so calls can be chained.
	public func bcc(_ bcc: String) -> Self {
		params.append(("bcc", bcc))
		return self
	}

	/// Send the created email.
	/// - note: You have to configure the email properties using this class methods
	/// ```
	///  WeDeploy.service("service-url")
	/// 	.to("some@email.com")
	///		.message("this is a message")
	/// 	.send()
	/// ```
	public func send() -> Promise<String> {
		var builder = requestBuilder
				.path("/emails")

		for param in params {
			builder = builder.form(name: param.name, value: param.value)
		}

		return builder
			.post().then { response in
				try response.validateBody(bodyType: String.self)
			}
	}

	/// Check the status of a mail
	public func checkEmailStatus(id: String) -> Promise<String> {
		return requestBuilder
			.path("/emails/\(id)/status")
			.get()
			.then { response in
				try response.validateBody(bodyType: String.self)
			}
	}

}
