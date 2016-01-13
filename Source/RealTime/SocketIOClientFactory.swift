import Foundation
import Socket_IO_Client_Swift

public class SocketIOClientFactory {

	class func create(url: String, var options: Set<SocketIOClientOption> = [])
		-> SocketIOClient {

		if (!options.contains(.ForceNew(false))) {
			options.insert(.ForceNew(true))
		}

		let url = parseURL(url)

		options.insert(.ConnectParams(["EIO": "3", "url": url.path]))
		options.insert(.Path(url.path))

		let socket = SocketIOClient(socketURL: url.host, options: options)
		socket.connect()

		return socket
	}

	class func parseURL(url: String) -> (host: String, path: String) {
		let URL = NSURLComponents(string: url)!
		let host = URL.host ?? ""
		var port = ""

		if let p = URL.port where URL.port != 80 {
			port = ":\(p)"
		}

		let path = URL.path!

		return ("\(host)\(port)", path)
	}

}