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
        let app = CloudApp.init(appID: "xckzjbmtsbfb", appKey: "345f3324-c73c-4b15-94b5-9e89356c1b4e")
        app.setIsLogging(true)
        app.setMasterKey("f5cc5cb3-ba0d-446d-9e51-e09be23c540d")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    // MARK:- Test
    
    
    // Testing false date in custom date field
    func testFalseDateField(){
        let expectaion = expectationWithDescription("Should not save data incorrect date")
        let obj = CloudObject(tableName: "Student")
        obj.setString("dob", value: "yesterday")
        obj.save({
            (resp: CloudBoostResponse) in
            if(resp.success){
                XCTAssert(false)
            }
            expectaion.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)

    }
    
    // Saving data in custom date field
    func testCustomDateField(){
        let expectaion = expectationWithDescription("Should save data in custom date field")
        let obj = CloudObject(tableName: "Student")
        obj.setDate("dob", value: NSDate())
        obj.save({
            (resp: CloudBoostResponse) in
            print(obj.getDate("dob"))
            expectaion.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should not save data in email field with an incorrect email ( saving an invalid email, the test passes if the data is not saved"
    func testFalseEmailField(){
        let expectaion = expectationWithDescription("Should not save incorrect email")
        let obj = CloudObject(tableName: "Student")
        obj.setString("email", value: "randhir")
        obj.save({
            (resp: CloudBoostResponse) in
            if(resp.success){
                XCTAssert(false)
            }
            expectaion.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should save data in email field
    func testEmailField(){
        let expectaion = expectationWithDescription("Should save correct email")
        let obj = CloudObject(tableName: "Student")
        obj.setString("email", value: "randhir@gmail.com")
        obj.save({
            (resp: CloudBoostResponse) in
            if(resp.success == false){
                XCTAssert(false)
            }
            expectaion.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should not save data in URL with incorrect url
    func testFalseURLField(){
        let expectaion = expectationWithDescription("Should not save incorrect URL")
        let obj = CloudObject(tableName: "Student")
        obj.setString("url", value: "google")
        obj.save({
            (resp: CloudBoostResponse) in
            if(resp.success){
                XCTAssert(false)
            }
            expectaion.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should save data in URL with correct url
    func testURLField(){
        let expectation = expectationWithDescription("Should save correct URL")
        let obj = CloudObject(tableName: "Student")
        obj.setString("url", value: "http://google.com")
        obj.save({
            (resp: CloudBoostResponse) in
            resp.log()
            if(resp.success == false){
                XCTAssert(false)
            }
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testSaveJSON(){
        let expectation = expectationWithDescription("save a JSON object in a column")
        let obj = CloudObject(tableName: "Student")
        obj.set("parent", value: ["name":"ABC", "age":23])
        obj.save({
            (resp: CloudBoostResponse) in
            resp.log()
            if(resp.success == false){
                XCTAssert(false)
            }
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Save a list of numbers
    func testSaveList(){
        let expectation = expectationWithDescription("save a list of numbers in a column")
        let obj = CloudObject(tableName: "Student")
        obj.set("list", value: [22, 34, 54, 2, 12, 56, 78])
        obj.save({
            (resp: CloudBoostResponse) in
            resp.log()
            if(resp.success == false){
                XCTAssert(false)
            }
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    // Save the reslation
    func testSaveRelation(){
        let expectation = expectationWithDescription("save a list of numbers in a column")
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "randhir")
        obj.save({
            (resp: CloudBoostResponse) in
            resp.log()
            let obj2 = CloudObject(tableName: "Student")
            obj2.set("name", value: "Prabanjan")
            obj2.set("friend", value: obj.document)
            obj2.save({
                (resp2: CloudBoostResponse) in
                resp2.log()
                XCTAssert(resp2.success)
                expectation.fulfill()
            })
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }

    // Correct message to be displayed while saving a string in a integer
    func testSaveStringInInteger(){
        let expectation = expectationWithDescription("save a list of numbers in a column")
        let obj = CloudObject(tableName: "Student")
        obj.set("marks", value: 34)
        obj.save({
            (resp: CloudBoostResponse) in
            resp.log()
            if(resp.success == false){
                XCTAssert(false)
            }
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Delete an object with its ID
    func testDeleteObject(){
        let expectation = expectationWithDescription("delete object with ID")
        let obj = CloudObject(tableName: "Student")
        obj.setString("name", value: "Randhir Singh")
        obj.setInt("marks", value: 54)
        obj.save({
            (response: CloudBoostResponse) in
            response.log()
            obj.delete({
                (response: CloudBoostResponse) in
                response.log()
                if (response.success) {
                    obj.delete({
                        (resp: CloudBoostResponse) in
                        resp.log()
                        expectation.fulfill()
                    })
                }
            })
        })
        waitForExpectationsWithTimeout(60, handler: nil)

    }
    
    //
    
    // MARK:- Bulk test
    
    //should save array of CloudObject using bulk Api
    func testSaveArray() {
        let expectation1 = expectationWithDescription("testSaveArray")
        
        let obj1 = CloudObject(tableName: "Student")
        obj1.setString("name", value: "Randhir")
        obj1.setInt("marks", value: 88)
        
        let obj2 = CloudObject(tableName: "Student")
        obj2.setString("name", value: "Omar")
        obj2.setInt("marks", value: 99)
        
        let obj3 = CloudObject(tableName: "Student")
        obj3.setString("name", value: "Randhir")
        obj3.setInt("marks", value: 88)
        
        let obj4 = CloudObject(tableName: "Student")
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
    
    //should save and then delete array of CloudObject using bulk Api
    func testSaveAndDeleteArray() {
        let expectation1 = expectationWithDescription("testSaveArray")
        
        let obj1 = CloudObject(tableName: "Student")
        obj1.setString("name", value: "Randhir")
        obj1.setInt("marks", value: 88)
        
        let obj2 = CloudObject(tableName: "Student")
        obj2.setString("name", value: "Omar")
        obj2.setInt("marks", value: 99)
        
        let obj3 = CloudObject(tableName: "Student")
        obj3.setString("name", value: "Randhir")
        obj3.setInt("marks", value: 88)
        
        let obj4 = CloudObject(tableName: "Student")
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
    
    //Should properly save a relation in Bulk API
    func testRelationBulk(){
        let exp = expectationWithDescription("saving relation in bulk API")
        
        let obj = CloudObject(tableName: "Custom2");
        obj.set("newColumn1", value: "Course");
        let obj3 = CloudObject(tableName: "Custom3");
        obj3.set("address",value: "progress");
        obj.set("newColumn2",value: obj3.document);
        
        CloudObject.saveAll([obj,obj3], callback: {
            (response: CloudBoostResponse) in
            response.log()
            exp.fulfill()
        })
        
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testCloudObjectSaveRepeat() {
        //Number of objects to be saved
        let limit = 10
        
        let expectation1 = expectationWithDescription("testRepeatedSave")
        var count = 0
        func test(){
            let obj = CloudObject(tableName: "Student")
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

    
    // MARK: Encryption
    
    //should encrypt passwords
    func testShouldEncrypt(){
        let exp = expectationWithDescription("should encrypt password")
        let obj = CloudUser(username: Util.makeString(10), password: "password")
        obj.setEmail(Util.makeEmail())
        obj.save({
            (response: CloudBoostResponse) in
            if(response.object!["password"] as! String == "password"){
                print("Failed to encrypt")
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    //should not encrypt already encrypted passwords
    func testAvoidEncryptingTwice(){
        let exp = expectationWithDescription("should not encrypt password twice")
        let obj = CloudUser(username: Util.makeString(10), password: "password")
        obj.setEmail(Util.makeEmail())
        obj.save({
            (response1: CloudBoostResponse) in
            print(obj)
            if(obj.getPassword()! == "password"){
                print("Failed to encrypt")
                XCTAssert(false)
            }else{
                let passwd = obj.getPassword()
                obj.setDate("updatedAt", value: NSDate())
                obj.save({
                    (response2: CloudBoostResponse) in
                    print(obj)
                    if(obj.getPassword()! == passwd){
                        print("successfully saved without encrypting twice")
                    }else{
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)

    }
    
    // MARK: expires
    
    //should save a CloudObject after expire is set
    func testSaveAfterExpiresSet(){
        let exp = expectationWithDescription("save after expire is set")
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Vipul")
        obj.set("marks", value: 67)
        obj.setDate("expires", value: NSDate().dateByAddingTimeInterval(60*60))
        obj.save({
            (response: CloudBoostResponse) in
            response.log()
            if(!response.success){
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    
    // Should not show up expires objects in a cloud query
    func testExpiredObjectQuery(){
        let exp = expectationWithDescription("dont show expired objects in query")
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Randhir")
        obj.set("marks", value: 56)
        obj.setDate("expires", value: NSDate())
        obj.save({
            (response: CloudBoostResponse) in
            XCTAssert(response.success)
            let query1 = CloudQuery(tableName: "Student")
            try! query1.equalTo("name", obj: "Randhir")
            let query2 = CloudQuery(tableName: "Student")
            try! query2.lessThan("marks", obj: 70)
            
            let query = CloudQuery(tableName: "Student")
            try! query.or(query1, object2: query2)
            
            try! query.find({
                (response :CloudBoostResponse) in
                response.log()
                XCTAssert(response.success)
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    // show an object if the expiration data is set to be in future
    func testFutureExpireDate(){
        let exp = expectationWithDescription("show future expiring object")
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Randhir")
        obj.set("marks", value: 20)
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            query.findById(obj.getId()!, callbak: {
                (response2: CloudBoostResponse) in
                XCTAssert(response2.success)
                response2.log()
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
}
