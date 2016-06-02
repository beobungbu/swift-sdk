//
//  CloudPushTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/05/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudPushTest: XCTestCase {

    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "gzujzwtotool", appKey: "aee1e347-1d86-44e7-a21e-40dfb125b5b4")
        app.setIsLogging(true)
        app.setMasterKey("4d90e204-0350-4757-968f-61e33740ffe8")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Should fail to send notification without push settings
    func testShouldFail() {
        let exp = expectationWithDescription("Should fail to send notification without push settings")
        
        let obj = CloudObject(tableName: "Device")
        obj.set("deviceToken", value: "helloasgsgdsd")
        obj.set("deviceOS", value: "android")
        obj.set("timezone", value: "chile")
        obj.set("channels", value: ["pirates","hackers","stealers"])
        obj.set("metadata", value: ["appname":"hdhfhfhfhf"])
        
        obj.save() { response in
            response.log()
            
            let query = CloudQuery(tableName: "Device")
            try! query.containedIn("channels", data: ["hackers"])
            
            try! CloudPush.send(["title":"RT Bathula", "message":"check this, from iOS"], query: query, callback: {
                response in
                
                response.log()
                exp.fulfill()
            })
            
        }
        
        waitForExpectationsWithTimeout(60, handler: nil)
        
    }
    
    // should add a sample setting to an app
    func testAddSampleSettings(){
        let exp = expectationWithDescription("should add a sample setting to an app")
        
        let url = CloudApp.apiUrl + "/settings/" + CloudApp.getAppId()! + "/push"
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let json = [
            "apple":[
                "certificates":[]
            ],
            "android":[
                "credentials":[["senderId":"612557492786","apiKey":"AIzaSyCrJe7JeAmEULaZbEWBVZ8-t6GkvrkQXvI"]]
            ],
            "windows":[
                "credentials":[["securityId":"sdsd","clientSecret":"sdjhds"]]
            ]
        ]
        let dat = try! NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.init(rawValue: 0))
        let str = NSString(data: dat, encoding: NSUTF8StringEncoding)
        params["settings"] = str
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            response in
            
            response.log()
            exp.fulfill()
        })
        
        waitForExpectationsWithTimeout(30, handler: nil)
        
        
    }
    
    // Should save a device with deviceToken
    func testSaveDevice(){
        let exp = expectationWithDescription("save device")
        
        let obj = CloudObject(tableName: "Device")
        obj.set("deviceToken", value: "76f24c255aec434e20c2dc143860d5531fcf9f3ba5cc005e9999015bf4a16587")
        obj.set("deviceOS", value: "ios")
        obj.set("timezone", value: "india")
        obj.set("channels", value: ["pirates","hackers","stealers"])
        obj.set("metadata", value: ["appname":"hdhfhfhfhf"])

        obj.save({ response in
            if response.success {
                exp.fulfill()
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
        
    }
    
    // Should send message with data,query and callback
    func testSendMessage(){
        let exp = expectationWithDescription("send message")
        let query = CloudQuery(tableName: "Device")
        try! query.containedIn("channels", data: ["hackers"])
        
        try! CloudPush.send(["title":"Randhir Singh","message":"check this"], query: query, callback: { response in
            response.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    // Should send message with data and callback
    func testSendMessage2(){
        let exp = expectationWithDescription("send message")
        
        try! CloudPush.send(["title":"RT Bathula","message":"check this"], query: nil, callback: { response in
            response.log()
            exp.fulfill()
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    
    
    
    

}
