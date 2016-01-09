import Foundation
import Socket_IO_Client_Swift

public class RealTime {

	let socket: SocketIOClient

	init(options: [String: AnyObject]?) {
		let userOptions = options ?? [:]
		var socketOptions = Set<SocketIOClientOption>()

		for (key, value) in userOptions {
			if let option = RealTime.toOption(key, value: value) {
				socketOptions.insert(option)
			}
		}

		if (!socketOptions.contains(.ForceNew(false))) {
			socketOptions.insert(.ForceNew(true))
		}

		socket = SocketIOClient(
			socketURL: "localhost:8900", options: socketOptions)

		socket.connect()
	}

	public func on(event: String, _ callback: [AnyObject] -> ()) -> Self {
		socket.on(event, callback: { data, ack in
			callback(data)
		})

		return self
	}

	class func toOption(key: String, value: AnyObject)
		-> SocketIOClientOption? {

		switch (key, value) {
			case ("connectParams", let params as [String: AnyObject]):
				return .ConnectParams(params)

			case ("cookies", let cookies as [NSHTTPCookie]):
				return .Cookies(cookies)

			case ("extraHeaders", let headers as [String: String]):
				return .ExtraHeaders(headers)

			case ("forceNew", let force as Bool):
				return .ForceNew(force)

			case ("forcePolling", let force as Bool):
				return .ForcePolling(force)

			case ("forceWebsockets", let force as Bool):
				return .ForceWebsockets(force)

			case ("handleQueue", let queue as dispatch_queue_t):
				return .HandleQueue(queue)

			case ("log", let log as Bool):
				return .Log(log)

			case ("logger", let logger as SocketLogger):
				return .Logger(logger)

			case ("nsp", let nsp as String):
				return .Nsp(nsp)

			case ("path", let path as String):
				return .Path(path)

			case ("reconnectAttempts", let attempts as Int):
				return .ReconnectAttempts(attempts)

			case ("reconnects", let reconnects as Bool):
				return .Reconnects(reconnects)

			case ("reconnectWait", let wait as Int):
				return .ReconnectWait(wait)

			case ("secure", let secure as Bool):
				return .Secure(secure)

			case ("selfSigned", let selfSigned as Bool):
				return .SelfSigned(selfSigned)

			case ("sessionDelegate", let delegate as NSURLSessionDelegate):
				return .SessionDelegate(delegate)

			case ("voipEnabled", let enable as Bool):
				return .VoipEnabled(enable)

			default:
				return nil
		}
	}

}