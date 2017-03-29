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

public protocol Geo {
	var value: Any { get }
}

public struct GeoPoint: Geo {
	public let lat: Double
	public let long: Double

	public init(lat: Double, long: Double) {
		self.lat = lat
		self.long = long
	}

	public var value: Any {
		return "\(lat),\(long)"
	}
}

public struct BoundingBox: Geo {
	public let upperLeft: GeoPoint
	public let lowerRight: GeoPoint
	
	public init(upperLeft: GeoPoint, lowerRight: GeoPoint) {
		self.upperLeft = upperLeft
		self.lowerRight = lowerRight
	}
	
	public var value: Any {
		var val = [String: Any]()
		val["type"] = "envelope"
		val["coordinates"] = [upperLeft.value, lowerRight.value]

		return val
	}
}

public struct Circle: Geo {
	public let center: GeoPoint
	public let radius: Double
	
	public init(center: GeoPoint, radius: Double) {
		self.center = center
		self.radius = radius
	}

	public var value: Any {
		var val = [String: Any]()
		val["type"] = "circle"
		val["coordinates"] = center.value
		val["radius"] = radius

		return val
	}
}

public struct Line: Geo {
	public let coordinates: [GeoPoint]
	
	public init(coordinates: [GeoPoint]) {
		self.coordinates = coordinates
	}

	public var value: Any {
		var val = [String: Any]()
		val["type"] = "linestring"
		val["coordinates"] = coordinates.map({ $0.value })

		return val
	}
}

public struct Polygon: Geo {
	public let coordinates: [GeoPoint]
	
	public init(coordinates: [GeoPoint]) {
		self.coordinates = coordinates
	}

	public var value: Any {
		var val = [String: Any]()
		val["type"] = "polygon"
		val["coordinates"] = coordinates.map({ $0.value })

		return val
	}
}
