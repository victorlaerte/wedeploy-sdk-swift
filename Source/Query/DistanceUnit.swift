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

public enum DistanceUnit {
	case mile(Int)
	case yard(Int)
	case feet(Int)
	case inch(Int)
	case kilometer(Int)
	case meter(Int)
	case centimeter(Int)
	case millimeter(Int)
	case nauticalMile(Int)

	var value: String {
		switch self {
		case .mile(let unit):
			return "\(unit)mi"
		case .yard(let unit):
			return "\(unit)yd"
		case .feet(let unit):
			return "\(unit)ft"
		case .inch(let unit):
			return "\(unit)in"
		case .kilometer(let unit):
			return "\(unit)km"
		case .meter(let unit):
			return "\(unit)m"
		case .centimeter(let unit):
			return "\(unit)cm"
		case .millimeter(let unit):
			return "\(unit)mm"
		case .nauticalMile(let unit):
			return "\(unit)nmi"
		}
	}
}
