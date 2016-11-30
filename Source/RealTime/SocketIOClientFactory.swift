import Foundation
import SocketIO

public class SocketIOClientFactory {

//	class func create(
//			url: String, params: [URLQueryItem]? = [],
//			options: inout SocketIOClientConfiguration)
//		-> SocketIOClient {
//
//		if (!options.contains(.forceNew(false))) {
//			options.insert(.forceNew(true))
//		}
//
//		let url = parseURL(url: url, params: params)
//
//		options.insert(.connectParams(["EIO": "3", "url": url.query]))
//		options.insert(.path(url.path))
//
//		let socket = SocketIOClient(socketURL: url, config: options)
//		socket.connect()
//
//		return socket
//	}
//
//	class func parseURL(url: String, params: [URLQueryItem]? = [])
//		-> (host: String, path: String, query: String) {
//
//		let URL = NSURLComponents(string: url)!
//		URL.queryItems = params
//
//		let host = URL.host ?? ""
//		var port = ""
//
//		if let p = URL.port, URL.port != 80 {
//			port = ":\(p)"
//		}
//
//		let path = URL.path!
//		var query = path
//
//		if let q = URL.query {
//			query = "\(path)?\(q)"
//		}
//
//		return ("\(host)\(port)", path, query)
//	}

}
