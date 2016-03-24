//
//  CloudBoostTests.swift
//  CloudBoostTests
//
//  Created by Randhir Singh on 14/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudBoostTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "dirtubjnmgsa", appKey: "849b842c-3ff0-4456-80b2-ee5337d4ce86")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCloudObject() {
        let expectation1 = expectationWithDescription("testGetRequest")
        let obj = CloudObject(name: "Student")
        obj.setString("name", value: "Randhir")
        obj.setInt("marks", value: 99)
        obj.save({
            (response: CloudBoostResponse) in
            expectation1.fulfill()
            XCTAssert(response.success!)
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
        }
        
        
    }
    
}
