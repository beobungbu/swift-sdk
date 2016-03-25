//
//  CloudTableTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 24/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudTableTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "dirtubjnmgsa", appKey: "849b842c-3ff0-4456-80b2-ee5337d4ce86")
        app.setIsLogging(true)
        app.setMasterKey("46ee5286-d4f6-4113-b7b4-f2845fda6f14")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCloudTableGetAll() {
        let expectation1 = expectationWithDescription("testCloudTableGetAll")
        CloudTable.getAll({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            expectation1.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testCloudTableCreate(){
        let expectation1 = expectationWithDescription("testCreateTable")
        let teachers = CloudTable(tableName: "Teachers")
        teachers.setColumn(Column(name: "name", dataType: CloudBoostDataType.Text))
        teachers.setColumn(Column(name: "age", dataType: CloudBoostDataType.Number))
        teachers.save({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            expectation1.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    
    
}
