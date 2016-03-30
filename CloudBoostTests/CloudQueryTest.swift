//
//  CloudQueryTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 30/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudQueryTest: XCTestCase {

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

    func testQuery(){
        let exp = expectationWithDescription("test a basic query")
        let quer = CloudQuery(tableName: "Student")
        try! quer.lessThan("marks", obj: 50)
        try! quer.find({
            (response: CloudBoostResponse) in
            XCTAssert(response.success)
            response.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

}
