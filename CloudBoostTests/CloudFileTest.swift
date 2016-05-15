//
//  CloudFileTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 09/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudFileTest: XCTestCase {

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
    
    // Should Save a file with file data and name
    func testSaveFile(){
        let exp = expectationWithDescription("Should save file")
        
        let data = "ABCDEFGHIJKLMNOP"
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.save({
            (response: CloudBoostResponse) in
            if (response.success) {
                CloudFile.getFileFromUrl(NSURL(string: fileObj.getFileUrl()!)!, callback: {
                    (response: CloudBoostResponse) in
                    response.log()
                    XCTAssert(response.success)
                    if nsData == response.object as? NSData {
                        print("Matching data!!")
                    }else{
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
            } else {
                XCTAssert(false)
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should return the file with CloudObject
    func testReturnFileWithObject() {
        let exp = expectationWithDescription("Should return the file with CloudObject")
        
        let data = "ABCDEFGHIJKLMNOP"
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.save({
            (response: CloudBoostResponse) in
            if (response.success) {
                let obj = CloudObject(tableName: "FileTest")
                obj.set("file", value: fileObj)
                obj.save({
                    (response: CloudBoostResponse) in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            } else {
                XCTAssert(false)
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    //uploading file with progress
    func testUploadWithProgress() {
        let exp = expectationWithDescription("Should save file")
        
        let data = Util.makeString(59999)
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.uploadSave({
            response in
            response.log()
            if(response.complete){
                exp.fulfill()
            }
        })
        
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // save an array of files
    func testSaveArrayFiles(){
        let exp = expectationWithDescription("saving array of files")
        
        let type = "txt"
        
        let data1 = "ABCDEFGH"
        let name1 = "abc.txt"
        let fObje1 = CloudFile(name: name1, data: data1.dataUsingEncoding(NSUTF8StringEncoding)!, contentType: type)
        
        let data2 = "UVWXYZ"
        let name2 = "xyz.txt"
        let fObj2 = CloudFile(name: name2, data: data2.dataUsingEncoding(NSUTF8StringEncoding)!, contentType: type)
        
        CloudFile.saveAll([fObje1,fObj2], callback: {
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should return filelist with ID
    func testDaveFileList(){
        let exp = expectationWithDescription("saving file list")
        
        let type = "txt"
        
        let data1 = "ABCDEFGH"
        let name1 = "abc.txt"
        let fObje1 = CloudFile(name: name1, data: data1.dataUsingEncoding(NSUTF8StringEncoding)!, contentType: type)
        
        let data2 = "UVWXYZ"
        let name2 = "xyz.txt"
        let fObj2 = CloudFile(name: name2, data: data2.dataUsingEncoding(NSUTF8StringEncoding)!, contentType: type)
        
        CloudFile.saveAll([fObje1,fObj2], callback: {
            response in
            let obj = CloudObject(tableName: "FileTest")
            obj.set("fileList", value: [fObje1,fObj2])
            obj.save({
                response in
                guard let doc = response.object as? NSMutableDictionary else{
                    XCTAssert(false)
                    exp.fulfill()
                    return
                }
                let query = CloudQuery(tableName: "FileTest")
                query.findById(doc["_id"]as!String, callbak: {
                    response in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            })
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // should save the file and give the url
    func testSaveFileReturnURL()  {
        let exp = expectationWithDescription("save file and return url")
        let data = "ABCDEFGHIJKLMNOP"
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.save({
            (response: CloudBoostResponse) in
            response.log()
            guard let doc = response.object as? NSMutableDictionary else {
                XCTAssert(false)
                exp.fulfill()
                return
            }
            if doc["url"] as? String != nil {
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should delete a file
    func testDeleteFile() {
        let exp = expectationWithDescription("delete a saved file")
        
        let data = "ABCDEFGHIJKLMNOP"
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.save({
            (response: CloudBoostResponse) in
            try! fileObj.delete({
                response in
                response.log()
                XCTAssert(response.success)
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    // should save a new file
    func testSaveNewFile(){
        let exp = expectationWithDescription("Should save file")
        
        let data = "<a id=\"a\"><b id=\"b\">hey!</b></a>"
        let name = "htmlfile.html"
        let type = "text/html"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.save({
            (response) in
            if let url = fileObj.getFileUrl() {
                print("saved with url: \(url)")
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should delete a file
    func testDeleteNewFile(){
        let exp = expectationWithDescription("Should save file")
        
        let data = "<a id=\"a\"><b id=\"b\">hey!</b></a>"
        let name = "htmlfile.html"
        let type = "text/html"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.save({
            (response) in
            try! fileObj.delete({
                response in
                XCTAssert(response.success)
                if let url = fileObj.getFileUrl() {
                    print("could not delete file, url: \(url)")
                }else{
                    print("deleted!!")
                }
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    
    
    // should save the file and get it's contents later
    func testSaveFileGetContent()  {
        let exp = expectationWithDescription("save file and get its contents")
        let data = "ABCDEFGHIJKLMNOP"
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        fileObj.save({
            (response: CloudBoostResponse) in
            guard let doc = response.object as? NSMutableDictionary else {
                XCTAssert(false)
                exp.fulfill()
                return
            }
            if let url =  doc["url"] as? String {
                CloudFile.getFileFromUrl(NSURL(string: url)!, callback: {
                    response in
                    if response.success {
                        if let data = response.object as? NSData {
                            let content = NSString(data: data, encoding: NSUTF8StringEncoding)
                            print(content)
                        }
                    }
                })
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // MARK: ACL test
    
    // Should Save a file with file data and name
    func testSaveFileNoReadAccess(){
        let exp = expectationWithDescription("Should save file with no read access")
        
        let data = "ABCDEFGHIJKLMNOP"
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        let customACL = ACL()
        customACL.setPublicReadAccess(false)
        fileObj.setACL(customACL)
        fileObj.save({
            (response: CloudBoostResponse) in
            if (response.success) {
                CloudFile.getFileFromUrl(NSURL(string: fileObj.getFileUrl()!)!, callback: {
                    (response: CloudBoostResponse) in
                    response.log()
                    // check if unauthorized
                    if response.status == 500 {
                        XCTAssert(true)
                    }else{
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
            } else {
                XCTAssert(false)
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not delete file with no write access
    func testShouldNotDeleteWithoutWrite(){
        let exp = expectationWithDescription("attempt to delete a saved file with no write access")
        
        let data = "ABCDEFGHIJKLMNOP"
        let name = "abc.txt"
        let type = "txt"
        
        let nsData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let fileObj = CloudFile(name: name, data: nsData!, contentType: type)
        let customACL = ACL()
        customACL.setPublicWriteAccess(false)
        fileObj.setACL(customACL)
        fileObj.save({
            (response: CloudBoostResponse) in
            try! fileObj.delete({
                response in
                // check if unauthorized
                if response.status == 500 {
                    XCTAssert(true)
                }else{
                    XCTAssert(false)
                }
                exp.fulfill()
            })
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // get cloud file
    func testGetFileQuery(){
        let exp = expectationWithDescription("query cloud file")
        let query = CloudQuery(tableName: "Student")
        query.include("file")
        try! query.find({response in
            response.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    

}
