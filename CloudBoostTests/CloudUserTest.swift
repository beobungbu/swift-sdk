//
//  CloudUserTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 28/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudUserTest: XCTestCase {

    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "xckzjbmtsbfb", appKey: "345f3324-c73c-4b15-94b5-9e89356c1b4e")
        app.setIsLogging(true)
        app.setMasterKey("f5cc5cb3-ba0d-446d-9e51-e09be23c540d")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    // Should sign up  a user
    func testUserSignup(){
        let expectation = expectationWithDescription("signup a user on the app")
        let user = CloudUser(username: "randhirsingh", password: "abcdef")
        user.setEmail("randhirsingh051@gmail.com")
        do{
            try user.signup({
                (resp: CloudBoostResponse) in
                if(!resp.success){
                    XCTAssert(false)
                }
                expectation.fulfill()
            })
        } catch let error as CloudBoostError {
            print(error)
        } catch {
            print("Could not catch!")
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    // Should login a user
    func testUserLogin(){
        let expectation = expectationWithDescription("login a user on the app")
        let user = CloudUser(username: "randhirsingh", password: "abcdef")
        user.setEmail("randhirsingh051@gmail.com")
        do{
            try user.signup({
                (resp: CloudBoostResponse) in
                if(!resp.success){
                    XCTAssert(false)
                }
                expectation.fulfill()
            })
        } catch let error as CloudBoostError {
            print(error)
        } catch {
            print("Could not catch!")
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // SHould not change password wher the user is logged in
    func testLoggedInPasswordChange(){
        let expectation = expectationWithDescription(("dont change password when logged in"))
        
        let user = CloudUser(username: "randhirsingh", password: "")
        user.set("password", value: passwd().pw_change)
        user.setEmail("randhirsingh051@gmail.com")
        try! user.signup({
            (response: CloudBoostResponse) in
            response.log()
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }
    
    // Should resset password
    func testRestPassword() {
        let expectation = expectationWithDescription("should reset password")
        
        CloudUser.resetPassword("randhirsingh051@gmail.com", callback: {
            (response: CloudBoostResponse) in
            response.log()
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should send a rest email with email setting and default templates
    func testResetEmail(){
        
    }
    
    // Should logout the user
    func testLogoutUser(){
        let expectaion = expectationWithDescription("logout user")
        
    }
    

}
