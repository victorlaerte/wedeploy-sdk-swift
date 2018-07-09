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
import RxSwift
import SocketIO

/// Represent the type of a socketIO event.
public enum RealTimeEventType: String {

	/// Event triggered when something changes.
	///
	/// - note: if you want a fine grained control over what changed used create, update, delete types.
	case changes

	/// Event triggered when an error occurs.
	case error

	/// Event triggered when an entity is created.
	case create

	/// Event triggered when an entity is updated.
	case update

	/// Event triggered when an entity is deleted.
	case delete

	/// Create a realtime event from the type and the items.
	///
	/// - parameter from: type of the event, in string format.
	/// - parameter eventItems: items sent in the event.
	///
	/// - returnss: A realtime event.
	public static func realTimeEvent(from type: String, eventItems: [Any]) -> RealTimeEvent? {
		guard let eventType = RealTimeEventType(rawValue: type) else { return nil }

		return realTimeEvent(from: eventType, eventItems: eventItems)
	}

	/// Create a realtime event from the type and the items.
	///
	/// - parameter from: type of the event.
	/// - parameter eventItems: items sent in the event.
	///
	/// - returnss: A realtime event.
	public static func realTimeEvent(from type: RealTimeEventType, eventItems: [Any]) -> RealTimeEvent {
		let document: [String: Any]
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

/// Represent a socketIO event.
public struct RealTimeEvent {

	/// Type of the event
	public let type: RealTimeEventType

	/// Content of the event.
	/// The dictionary will be different depending on the type:
	///
	/// - create, update, delete: this would contain a json with the detail of the changes in a "document" key.
	/// - changes: this would contain a json array with the changes in a "changes" key.
	/// - error: this would contain a error in a "error" key.
	public let document: [String: Any]

	/// Creates a RealTimeEvent with the content of the websocket event
	public init(type: RealTimeEventType, document: [String: Any]) {
		self.type = type
		self.document = document
	}
}

public extension SocketIOClient {

	/// Subscribes to the given event.
	///
	/// - parameter event: string representing the event to subscribe.
	///
	/// - returnss: An observable of the future events.
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

	/// Subscribes to the given array of events.
	///
	/// - parameter events: event to subscribe.
	/// - parameter callback: function that will be invoked upon receving a new event.
	///
	/// - returnss: An observable of the future events.
	func on(_ events: [RealTimeEventType], callback: @escaping (RealTimeEvent) -> Void) {
		events.forEach { on($0, callback: callback)}
	}

	/// Subscribes to the given event.
	///
	/// - parameter event: event to subscribe.
	/// - parameter callback: function that will be invoked upon receving a new event.
	func on(_ event: RealTimeEventType, callback: @escaping (RealTimeEvent) -> Void) {
		self.on(event.rawValue) { items, _ in
			let realTimeEvent = RealTimeEventType.realTimeEvent(from: event, eventItems: items)

			callback(realTimeEvent)
		}
	}

	/// Subscribes to the given event.
	///
	/// - parameter event: event to subscribe.
	///
	/// - returnss: An observable of the future events.
	func on(_ event: RealTimeEventType) -> Observable<RealTimeEvent> {
		return on(event.rawValue)
	}

	/// Subscribes to the given array of events.
	///
	/// - parameter events: event to subscribe.
	///
	/// - returnss: An observable of the future events.
	func on(_ events: [RealTimeEventType]) -> Observable<RealTimeEvent> {
		let realTimeEventsObservables = events.map { on($0) }

		return Observable.from(realTimeEventsObservables).merge()
	}

}
