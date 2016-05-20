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
        let app = CloudApp.init(appID: "zbzgfbmhvnzf", appKey: "d9c4cdef-7586-4fa2-822b-cb815424d2c8")
        app.setIsLogging(true)
        app.setMasterKey("2df6d3e7-a695-4ab0-b18a-d37a90af4dc9")
        CloudSocket.initialise(CloudApp.getSocketUrl())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //should create a table
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
    
    //should first create a table and then delete that table
    func testCreateAndDeleteTable(){
        let expectation1 = expectationWithDescription("should delete table after creating")
        let tableName = Util.makeString(5)
        let table = CloudTable(tableName: tableName)
        table.save({
            response in
            try! table.delete({
                response in
                XCTAssert(response.success)
                expectation1.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should create a table with random string name
    func testCreateTable(){
        let exp = expectationWithDescription("should create a table")
        let tableName = "pg19S"
        let table = CloudTable(tableName: tableName)
        table.save({
            response in
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(50, handler: nil)
    }

    
    // should delete a table created in above test
    func testDeleteTable(){
        let exp = expectationWithDescription("should delete a table")
        let tableName = "pg19S"
        let table = CloudTable(tableName: tableName)
        CloudTable.get(table, callback: {
            response in
            try! table.delete({
                response in
                XCTAssert(response.success)
                exp.fulfill()
            })
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    // should get a table information
    func testGetTableInfo(){
        let exp = expectationWithDescription("should get a table information")
        let table = CloudTable(tableName: "Teachers")
        CloudTable.get(table, callback: {
            response, table in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should update new column into the table
    func testShouldUpdateColumn(){
        let exp = expectationWithDescription("should update new column into the table")
        let tableName1 = Util.makeString(5)
        let tableName2 = Util.makeString(5)
        let table1 = CloudTable(tableName: tableName1)
        let table2 = CloudTable(tableName: tableName2)
        table1.save({
            response in
            table2.save({
                response in
                let column1 = Column(name: "Name11", dataType: CloudBoostDataType.Relation, required: true, unique: false)
                column1.setRelatedTo(table2)
                table1.addColumn(column1)
                table1.save({
                    response in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            })
            
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // should add a column to an existing table
    func testAddColumn(){
        let exp = expectationWithDescription("should add column")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response in
            let col = Column(name: "occupation", dataType: CloudBoostDataType.Text)
            table.addColumn(col)
            table.save({
                response in
                XCTAssert(response.success)
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should add a column to the table after save
    func testAddColumnAfterSave(){
        let exp = expectationWithDescription("should add a column to the table after save")
        let tableName = Util.makeString(5)
        let table = CloudTable(tableName: tableName)
        table.save({
            res in
            let col = Column(name: "name", dataType: CloudBoostDataType.Text)
            table.addColumn(col)
            table.save({
                res in
                XCTAssert(res.success)
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should get a table information
    func testGetTableInformation(){
        let exp = expectationWithDescription("should get table information")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response, table in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should get all tables
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
    
    // should not rename a table
    func testNotRename(){
        let exp = expectationWithDescription("should not rename table")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response in
            table.setTableName("Teachers2")
            table.save({
                response in
                response.log()
                if table.getTableName() == "Teachers2" {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not change type of table
    func testNotChangeTableType(){
        let exp = expectationWithDescription("should not change the table type")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response in
            table.setTableType("NewType")
            table.save({
                response in
                response.log()
                if table.getTableType() == "NewType" {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not rename a column
    func testNotRenameColumn(){
        let exp = expectationWithDescription("should not rename the column")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response in
            table.columns[0]["name"] = "NewName"
            table.save({
                response in
                response.log()
                if table.columns[0]["name"]as!String == "NewName" {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not change column data type
    func testNotChangeColumnDataType(){
        let exp = expectationWithDescription("should not change column data type")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response in
            table.columns[0]["dataType"] = CloudBoostDataType.GeoPoint.rawValue
            table.save({
                response in
                response.log()
                if table.columns[0]["dataType"]as!String == CloudBoostDataType.GeoPoint.rawValue {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not change unique property of a default column
    func testNotChangeUniqueProperty(){
        let exp = expectationWithDescription("should not change unique property of default column")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response in
            table.columns[0]["unique"] = false
            table.save({
                response in
                response.log()
                if table.columns[0]["unique"]as!Bool == false {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not change required property of a default column
    func testNotChangeRequiredProperty(){
        let exp = expectationWithDescription("should not change required property of default column")
        let table = CloudTable(tableName: "Teacher")
        CloudTable.get(table, callback: {
            response in
            table.columns[0]["required"] = false
            table.save({
                response in
                response.log()
                if response.success && table.columns[0]["required"]as!Bool == false {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should update column in a table
    func testUpdateColumn(){
        let exp = expectationWithDescription("should update column in a table")
        let table = CloudTable(tableName: "Teachers")
        CloudTable.get(table, callback: {
            response, table in
            if let table = table {
                print(table.document)
                let col = Column(name: "name", dataType: CloudBoostDataType.Text, required: true, unique: false)
                do {
                    try table.updateColumn(col)
                } catch {
                    print("name does not exist")
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                table.save({
                    response in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            } else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)

    }

    // MARK: Should Create All Test Tables
    
    // should create a table Employee
    func testCreateTableEmployee(){
        let exp = expectationWithDescription("should create Employee")
        let table = CloudTable(tableName: "Employee")
        
        let age = Column(name: "age", dataType: CloudBoostDataType.Number)
        let name = Column(name: "name", dataType: CloudBoostDataType.Text)
        let dob = Column(name: "dob", dataType: CloudBoostDataType.DateTime)
        let password = Column(name: "password", dataType: CloudBoostDataType.EncryptedText)
        
        table.addColumn(age)
        table.addColumn(name)
        table.addColumn(dob)
        table.addColumn(password)
                
        table.save({
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should create an empty table
    func testCreateEmptyTable(){
        let exp = expectationWithDescription("should create empty table")
        let table = CloudTable(tableName: "Empty")
        
        table.save({
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // should create a table with two underscore columns
    func testUnderscoreTable(){
        let exp = expectationWithDescription("should create a table with two underscore columns")
        let table = CloudTable(tableName: "UnderScoreTable_a")
        let age = Column(name: "Age_a", dataType: CloudBoostDataType.Text)
        table.addColumn(age)
        table.save({
            response in
            let age2 = Column(name: "Age_b", dataType: CloudBoostDataType.Text)
            table.addColumn(age2)
            table.save({
                response in
                response.log()
                XCTAssert(response.success)
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    // should create a table Company
    func testCreateTableCompany(){
        let exp = expectationWithDescription("should create company")
        let table = CloudTable(tableName: "Company")
        
        let revenu = Column(name: "revenue", dataType: CloudBoostDataType.Number)
        let name = Column(name: "name", dataType: CloudBoostDataType.Text)
        let file = Column(name: "file", dataType: CloudBoostDataType.File)
        
        table.addColumn(revenu)
        table.addColumn(name)
        table.addColumn(file)
        
        table.save({
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should create a table Address
    func testCreateTableAddress(){
        let exp = expectationWithDescription("should create company")
        let table = CloudTable(tableName: "Address")
        
        let city = Column(name: "city", dataType: CloudBoostDataType.Text)
        let pincode = Column(name: "pincode", dataType: CloudBoostDataType.Number)
        
        table.addColumn(city)
        table.addColumn(pincode)
        
        table.save({
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should update the table schema, set Employee(company)
    func testUpdateTableSchema(){
        let exp = expectationWithDescription("Should update the table schema")
        
        let table = CloudTable(tableName: "Employee")
        CloudTable.get(table, callback: {
            response, table in
            if let table = table {
                let rel = Column(name: "company", dataType: CloudBoostDataType.Relation)
                rel.setRelatedTo("Company")
                table.addColumn(rel)
                table.save({
                    response in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
    }
    
    // Should update the table schema, set Company(employee)
    func testUpdateTableSchema2(){
        let exp = expectationWithDescription("Should update the table schema")
        
        let table = CloudTable(tableName: "Company")
        CloudTable.get(table, callback: {
            response, table in
            if let table = table {
                // setting employee relation
                let rel = Column(name: "employee", dataType: CloudBoostDataType.List)
                rel.setRelatedTo("Employee")
                // setting address
                let addr = Column(name: "address", dataType: CloudBoostDataType.Relation)
                addr.setRelatedTo("Address")
                
                table.addColumn(rel)
                table.addColumn(addr)
                table.save({
                    response in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
    }
    

    
}
