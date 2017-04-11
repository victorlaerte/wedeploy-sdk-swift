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
import PromiseKit
import XCTest


internal extension Promise {

	func sync() -> (T?, Error?) {
		if isPending {
			var context = CFRunLoopSourceContext()

			let runLoop = CFRunLoopGetCurrent();
			let runLoopSource = CFRunLoopSourceCreate(nil, 0, &context);
			CFRunLoopAddSource(runLoop, runLoopSource, .defaultMode);

			self.always {
				CFRunLoopStop(runLoop);
			}
			while (self.isPending) {
				CFRunLoopRun();
			}
			CFRunLoopRemoveSource(runLoop, runLoopSource, .defaultMode);
		}


		return (value, error)
	}

	func valueOrFail(_ action: @escaping (T) -> Void) {
		self.tap { result in
			switch result {
			case .fulfilled(let value):
				action(value)
			case .rejected(let error):
				XCTFail("Rejected promise with error \(error)")
			}
		}
	}
}

