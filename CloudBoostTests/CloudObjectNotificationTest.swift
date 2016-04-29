//
//  CloudObjectNotificationTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 29/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudObjectNotificationTest: XCTestCase {

    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "zbzgfbmhvnzf", appKey: "d9c4cdef-7586-4fa2-822b-cb815424d2c8")
        app.setIsLogging(true)
        app.setMasterKey("2df6d3e7-a695-4ab0-b18a-d37a90af4dc9")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: Query on Cloud Object Notifications
    
    // limit: 1
    func testTheLimit(){
        let exp = expectationWithDescription("testing limits")
        var count = 0
        let query = CloudQuery(tableName: "Student")
        query.setLimit(2)
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            count += 1
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    for _ in 0...3{
                        let obj = CloudObject(tableName: "Student")
                        obj.set("name", value: "sample")
                        obj.save({res in})
                    }
                }
        })
        sleep(40)
        if count != 2 {
            XCTAssert(false)
        }
        exp.fulfill()
        waitForExpectationsWithTimeout(50, handler: nil)
    }

    // skip: 1
    func testSkip(){
        let exp = expectationWithDescription("testing skip")
        var count = 0
        let query = CloudQuery(tableName: "Student")
        query.setSkip(1)
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            count += 1
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    for _ in 0...3{
                        let obj = CloudObject(tableName: "Student")
                        obj.set("name", value: "sample")
                        obj.save({res in})
                    }
                }
        })
        sleep(40)
        if count != 2 {
            XCTAssert(false)
        }
        exp.fulfill()
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    
    //notification should work on equalTo Columns
    func testEqualTo1(){
        let exp = expectationWithDescription("testing equal to success")
        
        let query = CloudQuery(tableName: "Student")
        try! query.equalTo("name", obj: "Randhir")
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            if res![0].get("name") === "Randhir" {
                XCTAssert(true)
                CloudObject.off("Student", eventType: "created", callback: {
                    res in
                    exp.fulfill()
                })
            }
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir")
                    obj.save({res in})
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    //notification should work on equalTo Columns 2
    func testEqualTo2(){
        let exp = expectationWithDescription("testing equal to")
        
        let query = CloudQuery(tableName: "Student")
        try! query.equalTo("name", obj: "Randhir")
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            XCTAssert(false)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                XCTAssert(false)
                exp.fulfill()
            })
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "sample")
                    obj.save({res in
                        sleep(10)
                        exp.fulfill()
                    })
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    // notEqualTo Columns
    func testNotEqualTo1(){
        let exp = expectationWithDescription("testing not equal to success")
        
        let query = CloudQuery(tableName: "Student")
        try! query.notEqualTo("name", obj: "Randhir")
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            
            XCTAssert(true)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                exp.fulfill()
            })
            
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir1")
                    obj.save({res in})
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    //not equalTo Columns 2
    func testNotEqualTo2(){
        let exp = expectationWithDescription("testing not equal to")
        
        let query = CloudQuery(tableName: "Student")
        try! query.notEqualTo("name", obj: "Randhir")
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            XCTAssert(false)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                XCTAssert(false)
                exp.fulfill()
            })
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir")
                    obj.save({res in
                        sleep(10)
                        exp.fulfill()
                    })
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }

    //greater than: 1
    func testGreaterThan1(){
        let exp = expectationWithDescription("testing greater than")
        
        let query = CloudQuery(tableName: "Student")
        try! query.greaterThan("marks", obj: 50)
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            
            XCTAssert(true)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                exp.fulfill()
            })
            
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir1")
                    obj.set("marks", value: 55)
                    obj.save({res in})
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    //greater than: 2
    func testGreaterThan2(){
        let exp = expectationWithDescription("testing greater than")
        
        let query = CloudQuery(tableName: "Student")
        try! query.greaterThan("marks", obj: 50)
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            XCTAssert(false)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                XCTAssert(false)
                exp.fulfill()
            })
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir")
                    obj.set("marks", value: 45)
                    obj.save({res in
                        sleep(10)
                        exp.fulfill()
                    })
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }

    //less than: 1
    func testLessThan1(){
        let exp = expectationWithDescription("testing less than")
        
        let query = CloudQuery(tableName: "Student")
        try! query.lessThan("marks", obj: 50)
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            
            XCTAssert(true)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                exp.fulfill()
            })
            
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir1")
                    obj.set("marks", value: 45)
                    obj.save({res in})
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    //less than: 2
    func testLessThan2(){
        let exp = expectationWithDescription("testing less than")
        
        let query = CloudQuery(tableName: "Student")
        try! query.lessThan("marks", obj: 50)
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            XCTAssert(false)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                XCTAssert(false)
                exp.fulfill()
            })
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir")
                    obj.set("marks", value: 55)
                    obj.save({res in
                        sleep(10)
                        exp.fulfill()
                    })
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    //exists: 1
    func testExists1(){
        let exp = expectationWithDescription("testing less than")
        
        let query = CloudQuery(tableName: "Student")
        query.exists("marks")
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            
            XCTAssert(true)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                exp.fulfill()
            })
            
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir1")
                    obj.set("marks", value: 45)
                    obj.save({res in})
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    //exists: 2
    func testExists2(){
        let exp = expectationWithDescription("testing less than")
        
        let query = CloudQuery(tableName: "Student")
        query.exists("marks")
        
        CloudObject.on("Student", eventType: "created", query: query, handler: {
            res in
            XCTAssert(false)
            CloudObject.off("Student", eventType: "created", callback: {
                res in
                XCTAssert(false)
                exp.fulfill()
            })
            
            }, callback: {
                err in
                if err != nil {
                    print(err)
                    XCTAssert(false)
                    exp.fulfill()
                }else {
                    
                    let obj = CloudObject(tableName: "Student")
                    obj.set("name", value: "Randhir")                    
                    obj.save({res in
                        sleep(10)
                        exp.fulfill()
                    })
                }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }

}
