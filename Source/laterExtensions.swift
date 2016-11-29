//
//  laterExtensions.swift
//  Launchpad
//
//  Created by Victor Galán on 29/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation
import later
import RxSwift

public extension Promise {

	func toCallback(callback: @escaping (T?, Error?) -> ()) {
		self.done(block: callback)
	}

	func toObservable() -> Observable<T> {
		return Observable.create { observer in
			self.done { (value, error) in
				if let value = value {
					observer.on(.next(value))
					observer.on(.completed)
				}
				else {
					observer.on(.error(error!))
				}
			}

			return Disposables.create()
		}
	}
}
