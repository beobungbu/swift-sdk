//
//  CloudNotificationTests.swift
//  CloudBoost
//
//  Created by Randhir Singh on 24/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudNotificationTests: XCTestCase {

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

    //should publish data to the channel
    func testPublishDataToChannel(){
        let exp = expectationWithDescription("should publish data to the channel")
        try! CloudNotification.on("sample", callback: {
            response in
            response.log()
            exp.fulfill()
        })
        try! CloudNotification.publish("sample", data: "Randhir")
        waitForExpectationsWithTimeout(30, handler: nil)
    }

}
