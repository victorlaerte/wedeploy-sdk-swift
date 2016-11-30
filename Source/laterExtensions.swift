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
