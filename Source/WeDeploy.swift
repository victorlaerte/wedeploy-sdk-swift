//
//  WeDeploy.swift
//  Launchpad
//
//  Created by Victor Galán on 29/11/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation


public class WeDeploy : RequestBuilder {

	override public class func url(_ url: String) -> WeDeploy {
		return WeDeploy(url)
	}

	public func auth() -> WeDeployAuth {
		return WeDeployAuth(self.url)
	}

	public func data() -> Self {
		return self
	}

	public func email() -> Self {
		return self
	}
}
