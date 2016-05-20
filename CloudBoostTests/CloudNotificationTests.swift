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
        let app = CloudApp.init(appID: "zbzgfbmhvnzf", appKey: "d9c4cdef-7586-4fa2-822b-cb815424d2c8")
        app.setIsLogging(true)
        app.setMasterKey("2df6d3e7-a695-4ab0-b18a-d37a90af4dc9")
        CloudSocket.initialise(CloudApp.getSocketUrl())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // should subscribe to a channel
    func testSubscribe(){
        let exp = expectationWithDescription("should publish data to the channel")
        
        try! CloudNotification.on("sample",
          // handler for data received on 'sample'
          handler: {
            data, ack in
            print(data)
            exp.fulfill()
          },
          // callback from registering the handler
          callback: { error in
            if error != nil {
                print(error)
                XCTAssert(false)
            }
        })
        
        waitForExpectationsWithTimeout(120, handler: nil)

    }
    
    
    //should publish data to the channel
    func testPublishDataToChannel(){
        let exp = expectationWithDescription("should publish data to the channel")
        
        let data = "Randhir"
        CloudNotification.on("sample",
            // this is the handler that is called whenever a data is emmitted to the app's specified channe(here 'sample' is the channel name)
            handler: {
                data, ack in
                if data[0] as! String != "Randhir" {
                    XCTAssert(false)
                }
                exp.fulfill()
            },
            // this is the callback after the handler has been registered for listening to the channel
            callback: { error in
                if error == nil {
                    try! CloudNotification.publish("sample", data: data)
                }
        })
        
        waitForExpectationsWithTimeout(120, handler: nil)
    }
    
    // should stop listening to a channel
    func testStopListening(){
        let exp = expectationWithDescription("shold stop listening to data")
        
        let data = "Randhir"
        CloudNotification.on("sample",
                                  // this is the handler that is called whenever a data is emmitted to the app's specified channe(here 'sample' is the channel name)
            handler: {
                data, ack in
                XCTAssert(false)
                exp.fulfill()
            },
            // this is the callback after the handler has been registered for listening to the channel
            callback: { error in
                if error == nil {
                    CloudNotification.off("sample", callback: {error in
                        print("heyy")                        
                        try! CloudNotification.publish("sample", data: data)
                        sleep(5)
                        exp.fulfill()
                    })
                    
                }
        })

        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    
}
