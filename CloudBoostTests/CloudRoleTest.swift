//
//  CloudRoleTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 08/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudRoleTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "xckzjbmtsbfb", appKey: "345f3324-c73c-4b15-94b5-9e89356c1b4e")
        app.setIsLogging(true)
        app.setMasterKey("f5cc5cb3-ba0d-446d-9e51-e09be23c540d")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // should create a role
    func testSaveRole(){
        let exp = expectationWithDescription("Should create a Role")
        let roleName = Util.makeString(10)
        let role = CloudRole(roleName: roleName)
        
        role.save({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        role
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should retrieve a role
    func testRetrieveRole(){
        let exp = expectationWithDescription("retrieve role")
        let roleName = Util.makeString(10)
        let role = CloudRole(roleName: roleName)
        role.save({
            (response: CloudBoostResponse) in
            guard let res = response.object as? NSMutableDictionary else {
                XCTAssert(false)
                exp.fulfill()
                return
            }
            let query = CloudQuery(tableName: "Role")
            query.findById(res["_id"]as!String, callbak: {
                (response: CloudBoostResponse) in
                response.log()
                XCTAssert(response.success)
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

}
