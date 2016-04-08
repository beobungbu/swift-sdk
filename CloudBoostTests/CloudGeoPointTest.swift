//
//  CloudGeoPointTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 08/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudGeoPointTest: XCTestCase {

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

    // savelatitude and longitude with integer
    func testSaveLatLong() {
        let exp = expectationWithDescription("Save latitude and longitude")
        let point = try! CloudGeoPoint(latitude: 17.7, longitude: 18.9)
        let locationTest = CloudObject(tableName: "LocationTest")
        locationTest.set("location", value: point)
        locationTest.save({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should create a geo point with 0,0 
    func testGeo00(){
        let exp = expectationWithDescription("Save latitude and longitude")
        let point = try! CloudGeoPoint(latitude: 0, longitude: 0)
        let locationTest = CloudObject(tableName: "LocationTest")
        locationTest.set("location", value: point)
        locationTest.save({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)

    }
    
    // latitude and longitude when passing a valid numeric data as string type does not apply for swift SDK
    
    // should get data from server for near function
    func testNearFunction() {
        let exp = expectationWithDescription("testing near function")
        let query = CloudQuery(tableName: "LocationTest")
        let point = try! CloudGeoPoint(latitude: 17.7, longitude: 18.3)
        query.near("location", geoPoint: point, maxDistance: 400000, minDistance: 0)
        try! query.find({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should get list of CloudGeoPoint Object from server Polygon type geoWithin
    func testGeoWithinList() {
        let exp = expectationWithDescription("testing geo within function")
        let query = CloudQuery(tableName: "LocationTest")
        let loc1 = try! CloudGeoPoint(latitude: 18.4, longitude: 78.9)
        let loc2 = try! CloudGeoPoint(latitude: 17.4, longitude: 78.4)
        let loc3 = try! CloudGeoPoint(latitude: 17.7, longitude: 80.4)
        query.geoWithin("location", geoPoints: [loc1,loc2,loc3])
        try! query.find({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)

    }
    
    // should get list of CloudGeoPoint Object from server Polygon type geoWithin + limit
    func testGeoWithinListLimit() {
        let exp = expectationWithDescription("testing geo within function with limit")
        let query = CloudQuery(tableName: "LocationTest")
        let loc1 = try! CloudGeoPoint(latitude: 18.4, longitude: 78.9)
        let loc2 = try! CloudGeoPoint(latitude: 17.4, longitude: 78.4)
        let loc3 = try! CloudGeoPoint(latitude: 17.7, longitude: 80.4)
        query.geoWithin("location", geoPoints: [loc1,loc2,loc3])
        query.limit = 4
        try! query.find({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }
    
    //should get list of CloudGeoPoint Object from server for Circle type geoWithin
    func testGeoWithinRadius() {
        let exp = expectationWithDescription("testing geo within function with radius")
        let query = CloudQuery(tableName: "LocationTest")
        let loc = try! CloudGeoPoint(latitude: 17.3, longitude: 78.3)
        query.geoWithin("location", geoPoint: loc, radius: 1000)
        try! query.find({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }

    //should get list of CloudGeoPoint Object from server for Circle type geoWithin with limits
    func testGeoWithinRadiusLimit() {
        let exp = expectationWithDescription("testing geo within function with radius and limit")
        let query = CloudQuery(tableName: "LocationTest")
        let loc = try! CloudGeoPoint(latitude: 17.3, longitude: 78.3)
        query.geoWithin("location", geoPoint: loc, radius: 1000)
        query.limit = 4
        try! query.find({
            (response: CloudBoostResponse) in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should update a saved GeoPoint
    func testUpdateGeoPoint() {
        let exp = expectationWithDescription("update saved GeoPoint")
        let point = try! CloudGeoPoint(latitude: 17.7, longitude: 79.9)
        let locationTest = CloudObject(tableName: "LocationTest")
        locationTest.set("location", value: point)
        locationTest.save({
            (response: CloudBoostResponse) in
            if let point2 = locationTest.getGeoPoint("location") {
                try! point2.setLatitude(55)
                locationTest.set("location", value: point2)
                locationTest.save({
                    (response: CloudBoostResponse) in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    
    
}
