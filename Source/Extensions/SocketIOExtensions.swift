//
//  RequestBuilderExtensions.swift
//  WeDeploy
//
//  Created by Victor Galán on 27/12/2016.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation
import later
import RxSwift
import SocketIO


public extension SocketIOClient {

	func on(_ event: String) -> Observable<[Any]> {

		return Observable.create { [weak self] observer in
			self?.on(event) { items, _ in
				observer.on(.next(items))
			}

			return Disposables.create()
		}
	}
}
