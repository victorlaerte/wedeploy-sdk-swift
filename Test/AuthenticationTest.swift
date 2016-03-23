//
//  AuthenticationTest.swift
//  Launchpad
//
//  Created by Igor Matos  on 3/16/16.
//  Copyright © 2016 Liferay Inc. All rights reserved.
//

@testable import Launchpad
import XCTest

class AuthenticationTest: XCTestCase {
    
    
    let username = "igor.matos@liferay.com"
    let password = "weloveliferay"
    let url = "http://liferay.io/launchpad/swift/artists"
    var artists = [[String: AnyObject]]()
    var artistsToAdd = [
        [
            "name": "Rage Against The Machine",
            "genre": "Rock / Rap Rock"
        ],
        [
            "name": "Led Zeppelin",
            "genre": "Classic Rock"
        ]
    ]

    
    
    func testAuth_Username_and_Password() {
        let auth = Auth.create("username", password: "password")
        XCTAssert(auth.hasUsername())
        XCTAssert(auth.hasPassword())
        XCTAssertEqual(auth.username(), "username")
        XCTAssertEqual(auth.password(), "password")

    }
    
    override func tearDown() {
        deleteAllArtists()
    }
    
    override func setUp() {
        deleteAllArtists()
        
        for artistToAdd in artistsToAdd {
            let expectation = expect("setUp")
            
            Launchpad
                .url(url)
                .auth(username, password: password)
                .post(artistToAdd)
                .then { response in
                    self.artists.append(response.body as! [String: AnyObject])
                    expectation.fulfill()
                }
                .done()
            
            wait()
        }
    
    }
    
    private func deleteAllArtists() {
        let expectation = expect("tearDown")
        
        Launchpad
            .url(url)
            .auth(username, password: password)
            .delete()
            .then { status -> () in
                expectation.fulfill()
            }
            .done()
        
        wait()
    }
    
    func testAuthSuccess(){
        let expectation = expect("auth")
        
        Launchpad
            .url(url)
            .auth(username, password: password)
            .get()
            .then { response in
                guard let queryResponse = response.body as? [[String: AnyObject]] else {
                    return
                }
                
                XCTAssertEqual(queryResponse.count, 2)
                expectation.fulfill()
                
            }
            .done()
        
        wait()
    }
    
    
    func testAuthFail(){
        let expectation = expect("auth")
        
        Launchpad
            .url(url)
            .auth(username, password: "anypassword")
            .get()
            .then { response in
                guard let queryResponse = response.body as? [[String: AnyObject]] else {
                    return
                }
                
                XCTAssertEqual(queryResponse.count, 2)
                expectation.fulfill()
                
            }
            .done()
        
        wait()
    }
    
    func testApiWithoutAuth(){
        let expectation = expect("auth")
        
        Launchpad.url(url)
            .get()
            .then { response in
                guard let queryResponse = response.body as? [[String: AnyObject]] else {
                    return
                }
                
                XCTAssertNotEqual(queryResponse.count, 2)
                expectation.fulfill()
                
            }
            .done()
        
        wait()
    }
    
    func testBasicHeader() {
        let credentials = "bruno.farache@liferay.com:test"
        let cred = credentials.dataUsingEncoding(NSUTF8StringEncoding)
        let credentialsBase64 = cred!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let expectedHeader = "Basic \(credentialsBase64)"
        
        let auth = Auth("bruno.farache@liferay.com", "test")
        
        let launchpad = Launchpad.url(url).auth(auth)
        
        var request = Request(
            headers: launchpad.headers, url: launchpad.url, params: launchpad.params)
        
        request = launchpad
                .resolveAuthentication(request)
        
        let header = request.headers["Authorization"]
        XCTAssertEqual(expectedHeader, header)
    }
    
    
    
}
