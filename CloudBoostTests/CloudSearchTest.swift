//
//  CloudSearchTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 22/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudSearchTest: XCTestCase {

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

    // should get data from server for near function
    func testGetNear(){
        let exp = expectationWithDescription("should get data from server for near function")
        let custom = CloudTable(tableName: "CustomGeoPoint")
        let newCol7 = Column(name: "location", dataType: CloudBoostDataType.GeoPoint)
        custom.addColumn(newCol7)
        custom.save({
            response in
            if response.success {
                let loc = try! CloudGeoPoint(latitude: 17.7, longitude: 80)
                let obj = CloudObject(tableName: "CustomGeoPoint")
                obj.set("location", value: loc)
                obj.save({
                    response in
                    if response.success {
                        let sFilter = SearchFilter()
                        sFilter.near("location", geoPoint: loc, distance: 1)
                        let search = CloudSearch(tableName: "CloudGeoPoint", searchQuery: nil, searchFilter: sFilter)
                        search.setLimit(10)
                        search.setSkip(1)
                        try! search.search({
                            response in
                            response.log()
                            exp.fulfill()
                        })
                    }else{
                        XCTAssert(false)
                        exp.fulfill()
                    }
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // Equal to should work in CloudSearch over CloudObject
    func testEqualTo(){
        let exp = expectationWithDescription("equal to should work")
        let custom = CloudTable(tableName: "CustomRelation")
        let newCol7 = Column(name: "newColumn7", dataType: CloudBoostDataType.Relation)
        newCol7.setRelatedTo("Student")
        custom.addColumn(newCol7)
        custom.save({
            response in
            if response.success {                
                let obj = CloudObject(tableName: "CustomRelation")
                let obj2 = CloudObject(tableName: "Student")
                obj2.set("name", value: "Randhir")
                obj.set("newColumn7", value: obj2)
                obj.save({
                    response in
                    if response.success {
                        let sFilter = SearchFilter()
                        sFilter.equalTo("newColumn7", data: obj.get("newColumn7")!)
                        let search = CloudSearch(tableName: "CustomRelation", searchQuery: nil, searchFilter: sFilter)
                        try! search.search({
                            response in
                            response.log()
                            exp.fulfill()
                        })
                    }else{
                        XCTAssert(false)
                        exp.fulfill()
                    }
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // should index object for search
    func testIndexObjects(){
        let exp = expectationWithDescription("index objects")
        let obj = CloudObject(tableName: "Student")
        obj.set("name", value: "Randhir")
        obj.save({
            response in
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should search over indexed objects
    func testOverIndexed(){
        let exp = expectationWithDescription("test over indexed objects")
        let query = SearchQuery()
        query.searchOn("name",query: "Randhir")
        
        let search = CloudSearch(tableName: "Student", searchQuery: query, searchFilter: nil)
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if "Randhir" != obj.get("name")as!String {
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // shoudl save indexed data
    func testSaveIndexedData() {
        let exp = expectationWithDescription("Saving indexed objects")
        
        let obj = CloudObject(tableName: "StudentSearch");
        obj.set("description", value: "This is nawaz");
        obj.set("age", value: 19);
        obj.set("name", value: "Nawaz Dhandala");
        obj.set("class", value: "Java");
        
        obj.save({
            response in
            let obj = CloudObject(tableName: "StudentSearch");
            obj.set("description", value: "This is Gautam");
            obj.set("age", value: 19);
            obj.set("name", value: "Gautam");
            obj.set("class", value: "C#");
            
            obj.save({
                response in
                let obj = CloudObject(tableName: "StudentSearch");
                obj.set("description", value: "This is Ravi");
                obj.set("age", value: 40);
                obj.set("name", value: "Ravi");
                obj.set("class", value: "C#");
                
                obj.save({
                    response in
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            })
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    //should search for object for a given value
    func testSearcGivenValue(){
        let exp = expectationWithDescription("Shoudl search for a given value")
        
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchFilter = SearchFilter()
        search.searchFilter?.equalTo("age", data: 19)
        
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if 19 != obj.get("age")as!Int {
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should search for object with a phrase
    func testSearchPhrase(){
        let exp = expectationWithDescription("should search for object with a phrase")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchQuery = SearchQuery()
        search.searchQuery?.phrase("description", query: "is Gautam", fuzziness: nil, priority: nil)
        try! search.search({
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should search for object with a wildcard
    func testWildcard(){
        let exp = expectationWithDescription("should search for object with a wildcard")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchQuery = SearchQuery()
        search.searchQuery?.wildcard("name", value: "*m", priority: nil)
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if "Gautam" != obj.get("name")as!String {
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should search for object with a startsWith
    func testStartsWith(){
        let exp = expectationWithDescription("should search for object with a startsWith")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchQuery = SearchQuery()
        search.searchQuery?.startsWith("name", value: "n", priority: nil)
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if "Nawaz Dhandala" != obj.get("name")as!String {
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should search for object with a mostColumns
    func testMostColumns() {
        let exp = expectationWithDescription("should search for object with a mostColumns")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchQuery = SearchQuery()
        try! search.searchQuery?.mostColumns(["name","description"], query: "Gautam", fuzziness: nil, all_words: nil, match_percent: nil, priority: nil)
        try! search.search({
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should search for object with a bestColumns
    func testBestColumns() {
        let exp = expectationWithDescription("should search for object with a bestColumns")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchQuery = SearchQuery()
        try! search.searchQuery?.bestColumns(["name","description"], query: "Gautam", fuzziness: nil, all_words: nil, match_percent: nil, priority: nil)
        try! search.search({
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should search values which are not equal to a given value
    func testNotEqualTo(){
        let exp = expectationWithDescription("should search values which are not equal to a given value")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchFilter = SearchFilter()
        search.searchFilter?.notEqualTo("age", data: 19)
        
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if 19 == obj.get("age")as!Int {
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)

    }
    
    // should limit the number of search results
    func testLimitSearch(){
        let exp = expectationWithDescription("should limit search results")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchFilter = SearchFilter()
        search.searchFilter?.notEqualTo("age", data: 19)
        search.setLimit(0)
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                if objArr.count > 0 {
                    XCTAssert(false)
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should sort the result in ascending order
    func testAscending(){
        let exp = expectationWithDescription("should sort the results in ascending order")
        let search = CloudSearch(tableName: "StudentSearch")
        search.orderByAsc("age")
        try! search.search({
            response in
            var ageArr = [Int]()
            for obj in response.object as! [CloudObject] {
                ageArr.append(obj.get("age")as!Int)
            }
            if ageArr == ageArr.sort() {
                print("ascending Sorted!")
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should sort the result in descending order
    func testDescending(){
        let exp = expectationWithDescription("should sort the results in descending order")
        let search = CloudSearch(tableName: "StudentSearch")
        search.orderByDesc("age")
        try! search.search({
            response in
            var ageArr = [Int]()
            for obj in response.object as! [CloudObject] {
                ageArr.append(obj.get("age")as!Int)
            }
            if ageArr == ageArr.sort().reverse() {
                print("descending Sorted!")
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should give elements in which a particular column exists 
    func testExists(){
        let exp = expectationWithDescription("should give elements in which a particular column exists")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchFilter = SearchFilter()
        search.searchFilter?.exists("name")
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if let _ = obj.get("name"){
                        XCTAssert(true)
                    }else{
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // search for records that do not have a certain column
    func testDoesNotExists(){
        let exp = expectationWithDescription("should give elements in which a particular column does not exists")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchFilter = SearchFilter()
        search.searchFilter?.doesNotExists("name")
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if let _ = obj.get("name"){
                        XCTAssert(true)
                    }else{
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    //should give records within a certain range
    func testRange(){
        let exp = expectationWithDescription("should give elements in a particular range")
        let search = CloudSearch(tableName: "StudentSearch")
        search.searchFilter = SearchFilter()
        search.searchFilter?.greaterThan("age", data: 19)
        search.searchFilter?.lessThan("age", data: 50)
        try! search.search({
            response in
            if let objArr = response.object as? [CloudObject] {
                for obj in objArr {
                    if let _ = obj.get("name"){
                        XCTAssert(true)
                    }else{
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // OR should work between tables
    func testOR(){
        let exp = expectationWithDescription("OR should work between tables")
        
        let obj1 = CloudObject(tableName: "Student")
        obj1.set("name", value: "Randhir")
        
        let obj2 = CloudObject(tableName: "StudentSearch")
        obj2.set("name", value: "Randhir")
        
        obj1.save({
            response in
            if response.success {
                obj2.save({
                    response in
                    if response.success{
                        let tables = ["StudentSearch", "Student"]
                        
                        let sq1  = SearchQuery()
                        sq1.searchOn("name", query: "Randhir", fuzziness: nil, all_words: nil, match_percent: nil, priority: nil)
                        
                        let sq2  = SearchQuery()
                        sq1.searchOn("name", query: "Randhir", fuzziness: nil, all_words: nil, match_percent: nil, priority: nil)
                        
                        let cs = CloudSearch(tableName: tables, searchQuery: nil, searchFilter: nil)
                        cs.searchQuery = SearchQuery()
                        cs.searchQuery?.or(sq1)
                        cs.searchQuery?.or((sq2))
                        
                        try! cs.search({
                            response in
                            response.log()
                            XCTAssert(response.success)
                            exp.fulfill()
                        })
                    }
                })
            }
            
        })
        waitForExpectationsWithTimeout(60, handler: nil)
        
    }
    
    // should run operator (precision) queries
    func testRunOperatorQueries(){
        let exp = expectationWithDescription("should run operator (precision) queries")
        
        let obj = CloudObject(tableName: "StudentSearch")
        obj.set("name", value: "RAVI")
        
        obj.save({
            response in
            let tables = ["StudentSearch"]
            let cs = CloudSearch(tableName: tables, searchQuery: nil, searchFilter: nil)
            cs.searchQuery = SearchQuery()
            cs.searchQuery?.searchOn("name", query: "ravi", fuzziness: nil, all_words: "and", match_percent: nil, priority: nil)
            cs.setLimit(9999)
            try! cs.search({
                response in
                response.log()
                XCTAssert(response.success)
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }

    //should run minimum percent (precision) queries
    func testPercent(){
        let exp = expectationWithDescription("should run minimum percent (precision) queries")
        
        let obj = CloudObject(tableName: "StudentSearch")
        obj.set("name", value: "RAVI")
        
        obj.save({
            response in
            let tables = ["StudentSearch"]
            let cs = CloudSearch(tableName: tables, searchQuery: nil, searchFilter: nil)
            cs.searchQuery = SearchQuery()
            cs.searchQuery?.searchOn("name", query: "ravi", fuzziness: nil, all_words: nil, match_percent: "75%", priority: nil)
            cs.setLimit(9999)
            try! cs.search({
                response in
                response.log()
                XCTAssert(response.success)
                exp.fulfill()
            })
            
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }

    // multi table search
    func testMultiTable(){
        let exp = expectationWithDescription("OR should work between tables")
        
        let obj1 = CloudObject(tableName: "Student")
        obj1.set("name", value: "RAVI")
        
        let obj2 = CloudObject(tableName: "StudentSearch")
        obj2.set("name", value: "ravi")
        
        obj1.save({
            response in
            if response.success {
                obj2.save({
                    response in
                    if response.success{
                        let tables = ["StudentSearch", "Student"]
                        
                        let cs = CloudSearch(tableName: tables, searchQuery: nil, searchFilter: nil)
                        cs.searchQuery = SearchQuery()
                        cs.searchQuery?.searchOn("name", query: "ravi", fuzziness: nil, all_words: nil, match_percent: nil, priority: nil)
                        
                        try! cs.search({
                            response in
                            response.log()
                            XCTAssert(response.success)
                            exp.fulfill()
                        })
                    }
                })
            }
            
        })
        waitForExpectationsWithTimeout(60, handler: nil)
        
    }
    
    // should save a latitude and longitude when passing data are number type
    func testSaveGeoPoint(){
        let exp = expectationWithDescription("should save a latitude and longitude when passing data are number type")
        let obj = CloudObject(tableName: "LocationTest")
        let geo = try! CloudGeoPoint(latitude: 17.7, longitude: 80.0)
        obj.set("location", value: geo)
        obj.save({
            response in
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
}
