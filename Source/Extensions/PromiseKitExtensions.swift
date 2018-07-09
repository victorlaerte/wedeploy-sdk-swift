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


/// All async methods in this SDK returns a Promise
/// Use this extension in case you wan to convert to other return types
///
/// Converting to callback:
/// ```
/// WeDeploy.data("someurl.com")
///		.get("things")
///		.toCallback { result, error in
///			// Do something with the result or error
///		}
/// ```
/// Converting to callback:
/// ```
/// WeDeploy.data("someurl.com")
///		.get("things")
///		.toObservable()
///		.subscribe(onNext: { result in
///			// Do something with result
///		},
///		onError: { error in
///			// Do something with the error
///		})
///		.disposed(by: bag)
/// ```
public extension Promise {

	/// Convert the promise to a callback based termination.
	///
	/// - parameter callback: function executed when the promise is resolved.
	func toCallback(callback: @escaping (T?, Error?) -> Void) {
		self.tap { result in
			switch result {
			case .fulfilled(let value):
				callback(value, nil)
			case .rejected(let error):
				callback(nil, error)
			}
		}
	}

	/// Convert the promise to an Observable
	func toObservable() -> Observable<T> {
		return Observable.create { observer in
			self.tap { result in
				switch result {
				case .fulfilled(let value):
					observer.onNext(value)
					observer.onCompleted()
				case .rejected(let error):
					observer.onError(error)
				}
			}

			return Disposables.create()
		}
	}
}
