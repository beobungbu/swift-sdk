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
        let app = CloudApp.init(appID: "zbzgfbmhvnzf", appKey: "d9c4cdef-7586-4fa2-822b-cb815424d2c8")
        app.setIsLogging(true)
        app.setMasterKey("2df6d3e7-a695-4ab0-b18a-d37a90af4dc9")
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
    
    // Should send message with data,query and callback
    func testSendMessage(){
        let exp = expectationWithDescription("send message")
        
        let obj = CloudObject(tableName: "Device")
        obj.set("deviceToken", value: "fOek_RfEqUw:APA91bGGWKZzgM0-s4Z-NK9t7cdDqUBsskidJ09bn_vTruycmRgk_zS2IYE591GMVP1SuaSc3m81spmw8lad23vtkMI8E8dZB-F9lTz44Ij1uw9Zy1m3405dscjnfnOHru0IpJQe3jef")
        obj.set("deviceOS", value: "ios")
        obj.set("timezone", value: "india")
        obj.set("channels", value: ["pirates","hackers","stealers"])
        obj.set("metadata", value: ["appname":"hdhfhfhfhf"])
        
        obj.save({ response in
            if response.success {
                let query = CloudQuery(tableName: "Device")
                try! query.containedIn("channels", data: ["hackers"])
                
                try! CloudPush.send(["title":"RT Bathula","message":"check this"], query: query, callback: { response in
                    response.log()
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
        
    }
    
    // Should send message with data and callback
    func testSendMessage2(){
        let exp = expectationWithDescription("send message")
        
        let obj = CloudObject(tableName: "Device")
        obj.set("deviceToken", value: "datasdsdszafua")
        obj.set("deviceOS", value: "ios")
        obj.set("timezone", value: "india")
        obj.set("channels", value: ["pirates","hackers","stealers"])
        obj.set("metadata", value: ["appname":"hdhfhfhfhf"])
        
        obj.save({ response in
            if response.success {
                
                try! CloudPush.send(["title":"RT Bathula","message":"check this"], query: nil, callback: { response in
                    response.log()
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    
    
    
    

}
