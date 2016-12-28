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
import SocketIO

public class SocketIOClientFactory {

	public class func create(
			url: String, params: [URLQueryItem]? = [],
			options: inout SocketIOClientConfiguration)
		-> SocketIOClient {

		if (!options.contains(.forceNew(false))) {
			options.insert(.forceNew(true))
		}

		let urlComponents = parseURL(url: url, params: params)

		options.insert(.connectParams(["EIO": "3", "url": urlComponents.query]))
		options.insert(.path(urlComponents.path))

		let socket = SocketIOClient(socketURL: URL(string: urlComponents.host)!, config: options)
		socket.connect()

		return socket
	}

	class func parseURL(url: String, params: [URLQueryItem]? = [])
		-> (host: String, path: String, query: String) {

		let URL = NSURLComponents(string: url)!
		URL.queryItems = params

		let host = URL.host ?? ""
		var port = ""

		if let p = URL.port, URL.port != 80 {
			port = ":\(p)"
		}

		let path = URL.path!
		let scheme = "\(URL.scheme ?? "http")://"
		var query = path

		if let q = URL.query {
			query = "\(path)?\(q)"
		}

		return ("\(scheme)\(host)\(port)", path, query)
	}

}
