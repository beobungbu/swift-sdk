//
//  CloudCacheTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudCacheTest: XCTestCase {

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
    
    // create a cache
    func testCreateCache(){
        let exp = expectationWithDescription("creating cache")
        let cache = try! CloudCache(cacheName: "newCache")
        try! cache.create({
            response in
            response.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // should add an item to cache
    func  testAddItemToCache() {
        let exp = expectationWithDescription("Add item to Cache")
        let cache = try! CloudCache(cacheName: "newCache")
        try! cache.set("name", value: "Randhir", callback: {
            response in
            response.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should add a string
    func testAddString(){
        let exp = expectationWithDescription("Add string to Cache")
        let string = "Sumit"
        let cache = try! CloudCache(cacheName: "newCache")
        try! cache.set("str", value: string, callback: {
            response in
            if let setString = response.object as? String {
                if setString != string {
                    XCTAssert(false)
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should add a number
    func testAddNumber() {
        let exp = expectationWithDescription("Add number to Cache")
        let number = 97
        let cache = try! CloudCache(cacheName: "newCache")
        try! cache.set("str", value: number, callback: {
            response in
            if let setString = response.object as? Int {
                if setString != number {
                    XCTAssert(false)
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should delete an item
    func testDeleteItem(){
        let exp = expectationWithDescription("delete an item from cache")
        let item = "Randhir"
        let cache = try! CloudCache(cacheName: "newCache")
        try! cache.set("test1", value: item, callback: {
            response in
            if let setString = response.object as? String {
                if setString != item {
                    XCTAssert(false)
                }else{
                    try! cache.deleteItem("test1", callback: {
                        response in
                        if response.success {
                            try! cache.get("test1", callback: {
                                response in
                                response.log()
                                exp.fulfill()
                            })                            
                        }
                    })
                }
            }else{
                XCTAssert(false)
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not create cache with empty name
    func testCreateCacheInvalidName(){
        let exp = expectationWithDescription("creating cache with empty name")
        do {
            let cache = try CloudCache(cacheName: "")
            try cache.create({
                response in
                response.log()
                exp.fulfill()
            })
        } catch {
            print("Invalid cache name")
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // shoudl not try to insert null values
    func testSetNullValue(){
        let exp = expectationWithDescription("set null values in cache")
        do {
            let cache = try CloudCache(cacheName: "newCache")
            try cache.set("name", value: nil, callback: {
                response in
                response.log()
                XCTAssert(false)
                exp.fulfill()
            })
        } catch {
            print("Invalid argumnet error")
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // get item counts in a cache
    func testGetItemCount(){
        let exp = expectationWithDescription("get item counts")
        do {
            let cache = try  CloudCache(cacheName: "newCache")
            try cache.getItemsCount({
                response in
                response.log()
                exp.fulfill()
            })
        } catch {
            print("Error in argumnet")
            XCTAssert(false)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // get items in cache
    func testGetItems(){
        let exp = expectationWithDescription("get items in cache")
        do {
            let cache = try CloudCache(cacheName: "newCache")
            try cache.set("values", value: ["name":"Randhir", "marks": 34] as NSDictionary, callback: {
                response in
                response.log()
                if response.success {
                    try! cache.get("values", callback: {
                        response in
                        if let dict = response.object as? NSDictionary {
                            if dict["name"]as!String == "Randhir" && dict["marks"]as!Int == 34 {
                                print("Values match")
                                exp.fulfill()
                            }
                        }
                    })
                }
            })
        } catch {
            XCTAssert(false)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // get all cache items
    func testGetAllCache(){
        let exp = expectationWithDescription("get all cache items")
        do {
            let cache = try CloudCache(cacheName: "newCache")
            try cache.set("values", value: ["name":"Randhir", "marks": 34] as NSDictionary, callback: {
                response in
                response.log()
                if response.success {
                    try! cache.get("values", callback: {
                        response in
                        if let dict = response.object as? NSDictionary {
                            if dict["name"]as!String == "Randhir" && dict["marks"]as!Int == 34 {
                                print("Values match")
                                try! cache.getAllItems({
                                    response in
                                    response.log()
                                    XCTAssert(response.success)
                                    exp.fulfill()
                                })
                            }
                        }
                    })
                }
            })
        } catch {
            XCTAssert(false)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: nil)

    }

    
    
    // should get information about the cache
    func testGetCacheInfo(){
        let exp = expectationWithDescription("get cache information")
        do {
            let cache = try CloudCache(cacheName: "newCache")
            try cache.set("values", value: ["name":"Randhir", "marks": 34] as NSDictionary, callback: {
                response in
                response.log()
                if response.success {
                    try! cache.get("values", callback: {
                        response in
                        if let dict = response.object as? NSDictionary {
                            if dict["name"]as!String == "Randhir" && dict["marks"]as!Int == 34 {
                                print("Values match")
                                try! cache.getInfo({
                                    response in
                                    response.log()
                                    XCTAssert(response.success)
                                    exp.fulfill()
                                })
                            }
                        }
                    })
                }
            })
        } catch {
            XCTAssert(false)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // Should get null when wrong cache info is requested
    func testWrongCacheInfoRequested(){
        let exp = expectationWithDescription("requesting invalid cache info")
        do{
            let cache = try CloudCache(cacheName: "aksjdhjkashd")
            try cache.getInfo({
                response in
                response.log()
                XCTAssert(response.success)
                if let resp = response.object as? String{
                    if resp != "null" {
                        XCTAssert(false)
                    }
                }else{
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        }catch {
            print("Error in argument")
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should get all the caches
    func testShouldGetAllCache(){
        let exp = expectationWithDescription("getting all the cache")
        let cache = try!CloudCache(cacheName: "newCache")
        try!cache.getAllCaches({
            resp in
            resp.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should get all the ITEMS
    func testShouldGetAllItems(){
        let exp = expectationWithDescription("getting all the items")
        let cache = try!CloudCache(cacheName: "newCache")
        try!cache.getAllItems({
            resp in
            resp.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should delete a cache from an app
    func testDeletaCacheFromApp(){
        let exp = expectationWithDescription("delete cache from app")
        let cache = try!CloudCache(cacheName: "newCache")
        try!cache.delete({
            resp in
            resp.log()
            XCTAssert(resp.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should throw error when deleting a wrong cache
    func testDeleteWrogCache(){
        let exp = expectationWithDescription("throw error while deleting wrong cache from app")
        let cache = try!CloudCache(cacheName: "sjdlkas")
        try!cache.delete({
            resp in
            resp.log()
            if resp.success {
                XCTAssert(false)
            }else{
                XCTAssert(true)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should throw error when clearing a wrong cache
    func testClearWrogCache(){
        let exp = expectationWithDescription("throw error while clearing wrong cache from app")
        let cache = try!CloudCache(cacheName: "sjdlkas")
        try!cache.clear({
            resp in
            resp.log()
            if resp.success {
                XCTAssert(false)
            }else{
                XCTAssert(true)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should clear a cache from an app.
    func testClearCache(){
        let exp = expectationWithDescription("clear cache from app")
        do {
            let cache = try CloudCache(cacheName: "newCache")
            try cache.set("values", value: ["name":"Randhir", "marks": 34] as NSDictionary, callback: {
                response in
                response.log()
                if response.success {
                    try! cache.get("values", callback: {
                        response in
                        if let dict = response.object as? NSDictionary {
                            if dict["name"]as!String == "Randhir" && dict["marks"]as!Int == 34 {
                                print("Values match")
                                try! cache.clear({
                                    response in
                                    if response.success {
                                        try!cache.get("values", callback: {
                                            resp in
                                            resp.log()
                                            XCTAssert(resp.success)
                                            exp.fulfill()
                                        })
                                    }else {
                                        XCTAssert(false)
                                        exp.fulfill()
                                    }
                                })
                            }else {
                                XCTAssert(false)
                                exp.fulfill()
                            }
                        } else {
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            })
        } catch {
            XCTAssert(false)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    
    // Should delete the entire caches from an app
    func testDeleteEntireCache(){
        let exp = expectationWithDescription("delete entire cache")
        do {
            let cache = try CloudCache(cacheName: "newCache")
            try cache.set("values", value: ["name":"Randhir", "marks": 34] as NSDictionary, callback: {
                response in
                response.log()
                if response.success {
                    try! cache.get("values", callback: {
                        response in
                        if let dict = response.object as? NSDictionary {
                            if dict["name"]as!String == "Randhir" && dict["marks"]as!Int == 34 {
                                print("Values match")
                                try! cache.deleteAll({
                                    response in
                                    if response.success {
                                        try!cache.get("values", callback: {
                                            resp in
                                            resp.log()
                                            XCTAssert(resp.success)
                                            exp.fulfill()
                                        })
                                    }else {
                                        XCTAssert(false)
                                        exp.fulfill()
                                    }
                                })
                            }else {
                                XCTAssert(false)
                                exp.fulfill()
                            }
                        } else {
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            })
        } catch {
            XCTAssert(false)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: nil)
    }

    
    
}
 