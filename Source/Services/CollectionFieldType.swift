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

/// Recursive type used to create collections in WeDeploy's data service
public enum CollectionFieldType {

	/// Field of type string.
	case string

	/// Field of type integer
	case integer

	/// Field of type long.
	case long

	/// Field of type float.
	case float

	/// Field of type double.
	case double

	/// Field of type boolean.
	case boolean

	/// Field of type date.
	case date

	/// Field of type geo point.
	case geoPoint

	/// Field of type string.
	case geoShape

	/// Field of type binary.
	case binary

	/// Field with other fields inside.
	case collectionFieldType(fields: [String : CollectionFieldType])
}

// swiftlint:disable cyclomatic_complexity
extension Dictionary where Key == String, Value == CollectionFieldType {

	func toJsonConvertible() -> [String: Any] {
		return self.mapValues { collectionFieldType in
			switch collectionFieldType {
			case .string:
				return "string"
			case .integer:
				return "integer"
			case .long:
				return "long"
			case .float:
				return "float"
			case .double:
				return "double"
			case .boolean:
				return "boolean"
			case .date:
				return "date"
			case .geoPoint:
				return "geo_point"
			case .geoShape:
				return "geo_shape"
			case .binary:
				return "binary"
			case .collectionFieldType(let fields):
				return fields.toJsonConvertible()
			}
		}
	}
}
