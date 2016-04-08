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
        let point = try! CloudGeoPoint(latitude: 17.7, longitude: 78.9)
        
    }
}
