//
//  CloudObjectTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 24/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudObjectTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "dirtubjnmgsa", appKey: "849b842c-3ff0-4456-80b2-ee5337d4ce86")
        app.setIsLogging(true)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveArray() {
        let expectation1 = expectationWithDescription("testSaveArray")
        
        let obj1 = CloudObject(name: "Student")
        obj1.setString("name", value: "Randhir")
        obj1.setInt("marks", value: 88)
        
        let obj2 = CloudObject(name: "Student")
        obj2.setString("name", value: "Omar")
        obj2.setInt("marks", value: 99)
        
        let obj3 = CloudObject(name: "Student")
        obj3.setString("name", value: "Randhir")
        obj3.setInt("marks", value: 88)
        
        let obj4 = CloudObject(name: "Student")
        obj4.setString("name", value: "Omar")
        obj4.setInt("marks", value: 99)
        
        CloudObject.saveAll([obj1, obj2, obj3, obj4], callback: {
            (response: CloudBoostResponse) in
            response.log()
            print(obj4.document)
            expectation1.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testSaveAndDeleteArray() {
        let expectation1 = expectationWithDescription("testSaveArray")
        
        let obj1 = CloudObject(name: "Student")
        obj1.setString("name", value: "Randhir")
        obj1.setInt("marks", value: 88)
        
        let obj2 = CloudObject(name: "Student")
        obj2.setString("name", value: "Omar")
        obj2.setInt("marks", value: 99)
        
        let obj3 = CloudObject(name: "Student")
        obj3.setString("name", value: "Randhir")
        obj3.setInt("marks", value: 88)
        
        let obj4 = CloudObject(name: "Student")
        obj4.setString("name", value: "Omar")
        obj4.setInt("marks", value: 99)
        
        CloudObject.saveAll([obj1, obj2, obj3, obj4], callback: {
            (response: CloudBoostResponse) in
            response.log()
            if(response.success){
                CloudObject.deleteAll([obj1, obj2, obj3, obj4], callback: {
                    (delResponse: CloudBoostResponse) in
                    delResponse.log()
                    print(obj4.document)
                    expectation1.fulfill()
                })
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    
    func testCloudObjectSaveAndDelete() {
        
        let expectation1 = expectationWithDescription("testGetRequest")
        let obj = CloudObject(name: "Student")
        obj.setString("name", value: "Randhir")
        obj.setInt("marks", value: 99)
        obj.save({
            (response: CloudBoostResponse) in
            response.log()
            obj.delete({
                (response: CloudBoostResponse) in
                response.log()
                XCTAssert(response.success)
                expectation1.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testCloudObjectSaveRepeat() {
        //Number of objects to be saved
        let limit = 10
        
        let expectation1 = expectationWithDescription("testRepeatedSave")
        var count = 0
        func test(){
            let obj = CloudObject(name: "Student")
            obj.setString("name", value: "Randhir")
            obj.setInt("marks", value: 99)
            obj.save({
                (response: CloudBoostResponse) in
                response.log()
                count += 1
                if(count<limit){
                    test()
                }else{
                    expectation1.fulfill()
                }
            })
        }
        test()
        waitForExpectationsWithTimeout(Double(30*limit), handler: nil)
    }

    
    
}
