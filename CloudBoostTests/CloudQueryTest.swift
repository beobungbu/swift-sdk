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
    
    // MARK: Encrypted tests
    
    // should get encrypted passwords
    func testEncryptedPasswords(){
        let exp = expectationWithDescription("query over encrypted data password")
        let username = Util.makeString(10)
        let obj = CloudUser(username: username, password: "password")
        obj.setEmail(Util.makeEmail())
        obj.save({
            (response: CloudBoostResponse) in
            if let doc = response.object as? NSMutableDictionary {
                if doc["password"] as! String != "password" {
                    // Continue with query
                    let query = CloudQuery(tableName: "User")
                    try! query.equalTo("password", obj: "password")
                    try! query.equalTo("username", obj: username)
                    try! query.find({
                        (response: CloudBoostResponse) in
                        if let res = response.object as? NSArray{
                            if(res.count>0){
                                XCTAssert(true)
                            }else{
                                XCTAssert(false)
                            }
                        }else{
                            XCTAssert(false)
                        }
                        exp.fulfill()
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
                
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // should get encrypted passwords over OR query
    func testEncryptedPasswordsORQuery(){
        let exp = expectationWithDescription("query over encrypted data password using OR")
        let username = Util.makeString(10)
        let obj = CloudUser(username: username, password: "password")
        obj.setEmail(Util.makeEmail())
        obj.save({
            (response: CloudBoostResponse) in
            if let doc = response.object as? NSMutableDictionary {
                if doc["password"] as! String != "password" {
                    // Continue with query
                    let query1 = CloudQuery(tableName: "User")
                    try! query1.equalTo("password", obj: "password")
                    
                    let query2 = CloudQuery(tableName: "User")
                    try! query2.equalTo("password", obj: "password1")
                    
                    let query = CloudQuery(tableName: "User")
                    try! query1.or(query1, object2: query2)
                    
                    try! query.find({
                        (response: CloudBoostResponse) in
                        if let res = response.object as? NSArray{
                            if(res.count>0){
                                XCTAssert(true)
                            }else{
                                XCTAssert(false)
                            }
                        }else{
                            XCTAssert(false)
                        }
                        exp.fulfill()
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
                
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not encrypt already encrypted passwords 
    func testAlreadyEncrypted(){
        let exp = expectationWithDescription("should not encrypt already encrypted passwords")
        let username = Util.makeString(10)
        let obj = CloudUser(username: username, password: "password")
        obj.setEmail(Util.makeEmail())
        obj.save({
            (response: CloudBoostResponse) in
            guard let doc = response.object as? NSMutableDictionary else {
                XCTAssert(false)
                exp.fulfill()
                return
            }
            // Continue with query
            let query = CloudQuery(tableName: "User")
            query.findById(doc["_id"] as! String, callbak: {
                (response: CloudBoostResponse) in
                guard let res = response.object as? [NSMutableDictionary] else {
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                let encyptedPassword = doc["password"] as! String
                let savedAgainEncrypted = res[0]["password"] as! String
                if(encyptedPassword != savedAgainEncrypted){
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    

    
    // MARK: Include List
    
    // Save a relation
    func testSaveRelation() {
        let exp = expectationWithDescription("save a relation")
        
        let obj = CloudObject(tableName: "Custom4")
        obj.set("newColumn1", value: "Course")
        let obj1 = CloudObject(tableName: "Student")
        obj1.set("name", value: "nawaz")
        let obj2 = CloudObject(tableName: "Student")
        obj2.set("name", value: "vipul")
        obj.set("newColumn7", value: [obj1,obj2])
        
        obj.save({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // save  a multi join
    func testSaveMultiJoin()  {
        let exp = expectationWithDescription("save a multi join")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("newColumn1", value: "Course")
        
        let obj2 = CloudObject(tableName: "Attributes")
        obj2.set("height", value: "170cm")
        
        let obj3 = CloudObject(tableName: "Skills")
        obj3.set("primary_skill", value: "Sleeping")
        
        obj2.set("skills", value: obj3.document)
        obj.set("attributes", value: obj2.document)
        
        obj.save({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should include a relation object when include is requested in a query
    func testSaveRelationWithInclude()  {
        let exp = expectationWithDescription("save a multi join")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("newColumn1", value: "Course")
        
        let obj2 = CloudObject(tableName: "Attributes")
        obj2.set("height", value: "170cm")
        
        let obj3 = CloudObject(tableName: "Skills")
        obj3.set("primary_skill", value: "Sleeping")
        
        obj2.set("skills", value: obj3.document)
        obj.set("attributes", value: obj2.document)
        
        obj.save({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // should return duplicate items in relation list after saving
    
    
    
    
    
    // MARK: tests
    
    let obj = CloudObject(tableName: "Student")
    
    func saveObject(){
        
    }
    
    //should save  data with a particular value
    func testSaveValue() {
        let exp = expectationWithDescription("save a data with particular value")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Randhir")
        obj.save({
            (response: CloudBoostResponse) in
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should save data with a particular value, testing substring function
    func testSaveDataWithParticularValue() {
        let exp = expectationWithDescription("testing substring function")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Sumit")
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            try! query.substring("name", subStr: "umit")
            try! query.find({
                (response: CloudBoostResponse) in
                response.log()
                guard let resArray = response.object as? [NSDictionary] else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                for res in resArray {
                    if res["name"] as! String != "Sumit" {
                        XCTAssert(false)
                        exp.fulfill()
                    }
                }
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // substring with an array
    func testSubStringWithArray() {
        let exp = expectationWithDescription("testing substring function")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Vipul")
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            try! query.substring("name", subStr: "umit")
            try! query.substring("name", subStr: "ipul")
            try! query.find({
                (response: CloudBoostResponse) in
                response.log()
                guard let resArray = response.object as? [NSDictionary] else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should return only selected columns
    func testSelectColumn() {
        let exp = expectationWithDescription("return only selected columns")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Vipul ABC")
        obj.set("marks", value: 107)
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            query.selectColumn("name")
            try! query.equalTo("marks", obj: 107)
            try! query.find({
                (response: CloudBoostResponse) in
                response.log()
                guard let resArray = response.object as? [NSDictionary] else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                print(resArray[0])
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // select column should work on distinct
    func testSelectDistinctCol() {
        let exp = expectationWithDescription("testing distinct function")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Vipul ABC")
        obj.set("marks", value: 107)
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            query.selectColumn("name")
            try! query.equalTo("marks", obj: 107)
            try! query.equalTo("id", obj: (response.object as! NSMutableDictionary)["_id"] as! String)
            query.distinct("id",callbak: {
                (response: CloudBoostResponse) in
                response.log()
                guard let resArray = response.object as? [NSDictionary] else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                if let _ = resArray[0]["marks"] as? String {
                    XCTAssert(false)
                }
                print(resArray[0])
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should retrieve items when coulemn name is null
    func testColumnNameNull() {
        let exp = expectationWithDescription("column name null")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Vipul XYZ")
        obj.set("marks", value: 107)
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            // putting a nil in a dictionary is as good as excuding that value
            try! query.find({
                (response: CloudBoostResponse) in
                guard let resArray = response.object as? [NSDictionary] else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                print(resArray.count)
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // demonstrate not equal to
    func testColumnNameNotEqualTo() {
        let exp = expectationWithDescription("not equal to")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Vipul")
        obj.set("marks", value: 107)
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            try! query.equalTo("id", obj: (response.object as! NSMutableDictionary)["_id"] as! String)
            try! query.notEqualTo("name", obj: "Vipul")
            try! query.find({
                (response: CloudBoostResponse) in
                guard let resArray = response.object as? [NSDictionary] else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                if resArray.count != 0 {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // sould find data with id
    func testFindDataWithID() {
        let exp = expectationWithDescription("find with id")
        
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Vipul")
        obj.set("marks", value: 107)
        obj.save({
            (response: CloudBoostResponse) in
            let query = CloudQuery(tableName: "Student")
            try! query.equalTo("id", obj: (response.object as! NSMutableDictionary)["_id"] as! String)
            try! query.find({
                (response: CloudBoostResponse) in
                guard let resArray = response.object as? [NSDictionary] else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                if resArray.count != 1 {
                    XCTAssert(false)
                }
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should return count as integer
    func testReturnCount() {
        let exp = expectationWithDescription("count")
        let query = CloudQuery(tableName: "Student")
        query.limit = 1000
        query.count({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should count the number of objects
    func testCountObjects(){
        let exp = expectationWithDescription("count")
        
        let obj1 = CloudObject(tableName: "countobjectxx")
        let obj2 = CloudObject(tableName: "countobjectxx")
        let obj3 = CloudObject(tableName: "countobjectxx")
        let obj4 = CloudObject(tableName: "countobjectxx")
        let arr = [obj1,obj2,obj3,obj4]
        CloudObject.saveAll(arr, callback: {
            (response0: CloudBoostResponse) in
            let query = CloudQuery(tableName: "countobjectxx")
            query.limit = 100
            query.count({
                (response: CloudBoostResponse) in
                response.log()
                if arr.count != response.object as! Int {
                    XCTAssert(false)
                }
                CloudObject.deleteAll(arr, callback: {
                    (response: CloudBoostResponse) in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            })
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // should count the number of objects with skip and limit
    func testCountObjectsSkipLimit(){
        let exp = expectationWithDescription("count")
        
        let obj1 = CloudObject(tableName: "countobjectxx")
        let obj2 = CloudObject(tableName: "countobjectxx")
        let obj3 = CloudObject(tableName: "countobjectxx")
        let obj4 = CloudObject(tableName: "countobjectxx")
        let arr = [obj1,obj2,obj3,obj4]
        CloudObject.saveAll(arr, callback: {
            (response0: CloudBoostResponse) in
            let query = CloudQuery(tableName: "countobjectxx")
            query.limit = 2
            query.skip = 1
            query.count({
                (response: CloudBoostResponse) in
                response.log()
                if response.object as! Int != 2{
                    XCTAssert(false)
                }
                CloudObject.deleteAll(arr, callback: {
                    (response: CloudBoostResponse) in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            })
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // find
}
