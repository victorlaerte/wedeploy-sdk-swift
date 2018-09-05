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

/// Distance unit used in the filters
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

/// Time interval used in the aggregations
public enum TimeInterval: String {
	case year, quarter, month, week, day, hour, minute, second
}

/// Time unit used in the aggregations
public enum TimeUnit {
	case days(Int)
	case hours(Int)
	case minute(Int)
	case seconds(Int)
	case milliseconds(Int)
	case microseconds(Int)
	case nanoseconds(Int)

	var rawValue: String {
		switch self {
			case .days(let unit):
				return "\(unit)d"
			case .hours(let unit):
				return "\(unit)h"
			case .minute(let unit):
				return "\(unit)m"
			case .seconds(let unit):
				return "\(unit)s"
			case .milliseconds(let unit):
				return "\(unit)ms"
			case .microseconds(let unit):
				return "\(unit)micros"
			case .nanoseconds(let unit):
				return "\(unit)nanos"
		}
	}
}


