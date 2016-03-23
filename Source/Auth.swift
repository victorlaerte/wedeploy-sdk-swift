//
//  Auth.swift
//  Launchpad
//
//  Created by Igor Matos  on 3/15/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

import Foundation

public class Auth {
    
    var _username: String?
    var _password: String?
    var _token: String?
    
    public init(_ username: String, _ password: String) {
        _username = username
        _password = password
    }
    
    public static func create(username: String, password: String) -> Auth {
        return Auth(username, password)
    }
    
    public func hasToken() -> Bool {
        if let token = _token {
            return true
        }else{
            return false
        }
    }
    
    public func hasUsername() -> Bool {
        if let username = _username {
            return true
        }else{
            return false
        }
    }
    
    public func hasPassword() -> Bool {
        if let password = _password {
            return true
        }else{
            return false
        }
    }
    
    public func username() -> String {
        return _username!
    }
    
    public func password() -> String {
        return _password!
    }
    
    public func token() -> NSString {
        return _token!
    }
}