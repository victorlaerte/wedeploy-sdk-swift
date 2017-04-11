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

public struct Range {

	public var from: Any?
	public var to: Any?

	public init(from: Any? = nil, to: Any? = nil) {
		self.from = from
		self.to = to
	}

	public var value: [String: Any] {
		var desc = [String: Any]()

		if let from = from {
			desc["from"] = from
		}
		if let to = to {
			desc["to"] = to
		}

		return desc
	}
}
