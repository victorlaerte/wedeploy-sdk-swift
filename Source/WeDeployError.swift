//
//  WeDeployError.swift
//  Launchpad
//
//  Created by Victor Galán on 29/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation

public enum WeDeployError : Error {

	case unauthorized
	case badRequest(message: String)
	case unknown
}
