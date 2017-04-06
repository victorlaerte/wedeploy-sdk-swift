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
import RxSwift
import SocketIO

public enum RealTimeEventType: String {
	case changes
	case error
	case create
	case update
	case delete

	public static func realTimeEvent(from type: String, eventItems: [Any]) -> RealTimeEvent? {
		guard let eventType = RealTimeEventType(rawValue: type) else { return nil }

		return realTimeEvent(from: eventType, eventItems: eventItems)
	}

	public static func realTimeEvent(from type: RealTimeEventType, eventItems: [Any]) -> RealTimeEvent {
		let document: [String : Any]
		switch type {
		case .create, .update, .delete:
			let rawEvent = eventItems[0] as! [String: Any]
			document = rawEvent["document"] as! [String: Any]

		case .changes:
			let rawEvent = eventItems[0] as? [[String: Any]]
			document = ["changes": rawEvent as Any]

		case .error:
			let error = eventItems[0]
			document = ["error": error]
		}

		return RealTimeEvent(type: type, document: document)
	}
}

public struct RealTimeEvent {
	public let type: RealTimeEventType
	public let document: [String : Any]
}

public extension SocketIOClient {

	func on(_ event: String) -> Observable<RealTimeEvent> {
		var selfRetained: SocketIOClient? = self

		return Observable.create { [weak self] observer in
			self?.on(event) { items, _ in
				guard let realTimeEvent = RealTimeEventType.realTimeEvent(from: event, eventItems: items) else {
					return
				}

				observer.on(.next(realTimeEvent))
			}

			return Disposables.create(with: {
				selfRetained?.removeAllHandlers()
				selfRetained = nil
			})
		}
	}

	func on(_ events: [RealTimeEventType], callback: @escaping (RealTimeEvent) -> Void) {
		events.forEach { on($0, callback: callback)}
	}

	func on(_ event: RealTimeEventType, callback: @escaping (RealTimeEvent) -> Void) {
		self.on(event.rawValue) { items, _ in
			let realTimeEvent = RealTimeEventType.realTimeEvent(from: event, eventItems: items)

			callback(realTimeEvent)
		}
	}

	func on(_ event: RealTimeEventType) -> Observable<RealTimeEvent> {
		return on(event.rawValue)
	}

	func on(_ events: [RealTimeEventType]) -> Observable<RealTimeEvent> {
		let realTimeEventsObservables = events.map { on($0) }

		return Observable.from(realTimeEventsObservables).merge()
	}

}
