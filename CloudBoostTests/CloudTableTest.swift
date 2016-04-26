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
        let app = CloudApp.init(appID: "xckzjbmtsbfb", appKey: "345f3324-c73c-4b15-94b5-9e89356c1b4e")
        app.setIsLogging(true)
        app.setMasterKey("f5cc5cb3-ba0d-446d-9e51-e09be23c540d")
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
    
    func testDeleteTable(){
        let exp = expectationWithDescription("should delete a table")
        let table = CloudTable(tableName: "QueryPaginate")
        CloudTable.get(table, callback: {
            response in
            response.log()
            print(table.document)
            try! table.delete({
                response in
                response.log()
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(50, handler: nil)
    }

    
    
}
