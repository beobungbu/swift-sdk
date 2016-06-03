//
//  CloudQuery.swift
//  CloudBoost
//
//  Created by Randhir Singh on 30/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudQuery{

    var tableName: String?

    private var query = NSMutableDictionary()
    private var select = NSMutableDictionary()
    private var sort = NSMutableDictionary()
    private let body = NSMutableDictionary()
    
    private var include = [String]()
    private var includeList = [String]()

    private var _include = [String]()
    private var _includeList = [String]()
    
    var skip = 0
    var limit = 10
    
    public var objectClass: CloudObject.Type? = nil
    
    // constructor
    public init(tableName: String,
        objectClass: CloudObject.Type? = nil) {
    
        self.tableName = tableName
        self.objectClass = objectClass
        
        query["$include"] = _include
        query["$includeList"] = _includeList
                
    }
    
    // getter and setters for limit
    public func getLimit() -> Int {
        return limit
    }
    
    public func setLimit(limit: Int) {
        self.limit = limit
    }
    
    // getter and setters for skip
    public func getSkip() -> Int {
        return skip
    }
    
    public func setSkip(skip: Int) {
        self.skip = skip
    }
    
    // getter and setters for tableName
    public func getTableName() -> String?{
        return tableName
    }
    
    public func setTableName(tableName: String) {
        self.tableName = tableName
    }
    
    // Getter and setters for select statements
    public func getSelect() -> NSMutableDictionary {
        return select
    }
    
    public func setSelect(select: NSMutableDictionary){
        self.select = select
    }
    
    // Getter and setter for includeList and include
    public func getIncludeList() -> [String] {
        return includeList
    }
    
    public func setIncludeList(includeList: [String]){
        self.includeList = includeList
    }
    
    public func getInclude() -> [String] {
        return include
    }
    
    public func setInclude(include: [String]){
        self.include = include
    }

    // getter and setter for Sort
    public func getSort() -> NSMutableDictionary {
        return sort
    }
    
    public func setSort(sort: NSMutableDictionary){
        self.sort = sort
    }
    
    // For $includeList and $include
    public func get_includeList() -> [String] {
        return _includeList
    }
    
    public func set_includeList(_includeList: [String]){
        self._includeList = _includeList
    }
    
    public func get_include() -> [String] {
        return _include
    }
    
    public func set_include(_include: [String]){
        self._include = _include
    }
    
    // getter and setter for query
    public func getQuery() -> NSMutableDictionary {
        return query
    }
    
    public func setQuery(query: NSMutableDictionary){
        self.query = query
    }
    
    // MARK: query elements
    
    public func selectColumn(column: String){
        if self.select.count == 0 {
            select["_id"] = 1
            select["createdAt"] = 1
            select["updatedAt"] = 1
            select["ACL"] = 1
            select["_type"] = 1
            select["_tableName"] = 1
        }
        
        select[column] = 1
        
    }
    
    public func doNotSelectColumn(column: String){
        select[column] = 0
    }
    
    /**
     * CloudQuery Search, caseSensitive and diacriticSensitive defaults to false
     *
     * @param search
     * @param language
     * @param caseSensitive
     * @param diacriticSensitive
     */
    public func search(search: String, language: String? = "en", caseSensitive: Bool? = nil, diacriticSensitive: Bool? = nil) {
        let textFields = NSMutableDictionary()
        
        textFields["$search"] = search
        textFields["$language"] = language
        textFields["$caseSensitive"] = caseSensitive
        textFields["$diacriticSensitive"] = diacriticSensitive
        
        self.query["$text"] = textFields
    }
    
    /**
     * CloudQuery Or
     *
     *
     * @param object1
     * @param object2
     * @throws CLoubBoostError
     */
    public func or(object1: CloudQuery, object2: CloudQuery) throws {
        
        guard let tableName1 = object1.getTableName() else{
            throw CloudBoostError.InvalidArgument
        }
        guard let tableName2 = object2.getTableName() else {
            throw CloudBoostError.InvalidArgument
        }
        
        if(tableName1 != tableName2){
            throw CloudBoostError.InvalidArgument
        }
        
        var array = [NSDictionary]()
        array.append(object1.getQuery())
        array.append(object2.getQuery())
        
        self.query["$or"] = array
        
    }
    
    /**
     *
     * CloudQuery EqualTo
     *
     *
     * @param columnName
     * @param obj
     * @return CloudQuery good for chaining requests
     * @throws CLoubBoostError
     */
    public func equalTo(columnName: String, obj: AnyObject?) throws -> CloudQuery {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        var obj = obj
        if let ob = obj as? CloudObject {
            _columnName = _columnName + "._id"
            if let id = ob.getId() {
                obj = id
            }else{
                throw CloudBoostError.InvalidArgument
            }
        }
        if let ob = obj as? CloudRole {
            _columnName = _columnName + "._id"
            if let id = ob.getId() {
                obj = id
            }else{
                throw CloudBoostError.InvalidArgument
            }
        }
        query[_columnName] = obj
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
        
        return self
    }
    
    /**
     *
     * CloudQuery Not Equal To
     *
     * @param columnName
     * @param obj
     * @return CloudQuery
     * @throws CLoubBoostError
     */
    public func notEqualTo(columnName: String, obj: AnyObject) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        var obj = obj
        if let ob = obj as? CloudObject {
            _columnName = _columnName + "._id"
            if let id = ob.getId() {
                obj = id
            }else{
                throw CloudBoostError.InvalidArgument
            }
        }
        if let ob = obj as? CloudRole {
            _columnName = _columnName + "._id"
            if let id = ob.getId() {
                obj = id
            }else{
                throw CloudBoostError.InvalidArgument
            }
        }
        query[_columnName] = [ "$ne" : obj ]
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
    }
    
    public func lessThan(columnName: String, obj: AnyObject) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$lt":obj]
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
    }
    
    public func lessThanEqualTo(columnName: String, obj: AnyObject) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$lte":obj]
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
    }
    
    public func greaterThan(columnName: String, obj: AnyObject) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$gt":obj]
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }

    }
    
    public func greaterThanEqualTo(columnName: String, obj: AnyObject) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$gte":obj]
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
        
    }

    
    public func substring(columnName: String, subStr: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$regex": ".*" + subStr + ".*"]
    }
    
    public func startsWith(columnName: String, str: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$regex": "^" + str]
    }
    
    public func containsAll(columnName: String, obj: [String]) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$all":obj]
    }
    
    public func regex(columnName: String, exp: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$regex":exp]
    }
    
    /**
     *
     * CloudQuery ContainedIn
     *
     * @param columnName
     * @param data
     * @return CloudQuery
     * @throws CloudBoostExcetion
     */
    public func containedIn(columnName: String, data: [AnyObject]) throws -> CloudQuery{
        var _columnName = columnName
        if(columnName == "id" || columnName == "expires"){
            _columnName = "_" + columnName
        }
        var column = NSMutableDictionary()
        if let col = self.query[_columnName] as? NSMutableDictionary {
            column = col
        }
        
        var _in_ = [String]()
        var _nin_ = [String]()
        if data as? [String] != nil || data as? [CloudObject] != nil || data as? [Int] != nil || data as? [Double] != nil {
            var object = [CloudObject]()
            
            query["$include"] = _include
            query["$includeList"] = _includeList
            
            if column["$in"] == nil {
                column["$in"] = [String]()
            }
            if column["$nin"] == nil {
                column["$nin"] = [String]()
            }
            
            _in_ = column["$in"] as! [String]
            _nin_ = column["$nin"] as! [String]

            if data as? [CloudObject] != nil {
                _columnName = _columnName == "_id" ? _columnName : _columnName + "._id"
                var dataz = [String]()
                for (index, el) in data.enumerate() {
                    object.insert(el as! CloudObject, atIndex: index)
                    if let id = object[index].getId() {
                        dataz.append(id)
                    }else{
                        throw CloudBoostError.InvalidArgument
                    }
                }
                
                for (index, dat) in dataz.enumerate() {
                    if _in_.indexOf(dat) == nil {
                        _in_.append(dat)
                    }
                    if _nin_.indexOf(dat) != nil {
                        _nin_.removeAtIndex(index)
                    }
                }
                
            } else {
                for (index, dat) in data.enumerate() {
                    if _in_.indexOf(dat.description) == nil {
                        _in_.append(dat.description)
                    }
                    if _nin_.indexOf(dat.description) != nil {
                        _nin_.removeAtIndex(index)
                    }
                }
            }
            
            column["$in"] = _in_
            column["$nin"] = _nin_
            
            self.query[_columnName] = column
        } else {
            throw CloudBoostError.InvalidArgument
        }
        
        return self
    }
    
    /**
     *
     * CloudQuery notContainedIn
     *
     * @param columnName
     * @param data
     * @return CloudQuery
     * @throws CloudBoostExcetion
     */
    public func notContainedIn(columnName: String, data: [AnyObject]) throws -> CloudQuery{
        var _columnName = columnName
        if(columnName == "id" || columnName == "expires"){
            _columnName = "_" + columnName
        }
        var column = NSMutableDictionary()
        if let col = self.query[_columnName] as? NSMutableDictionary {
            column = col
        }
        
        var _in_ = [String]()
        var _nin_ = [String]()
        if data as? [String] != nil || data as? [CloudObject] != nil || data as? [Int] != nil || data as? [Double] != nil {
            var object = [CloudObject]()
            
            query["$include"] = _include
            query["$includeList"] = _includeList
            
            if column["$in"] == nil {
                column["$in"] = [String]()
            }
            if column["$nin"] == nil {
                column["$nin"] = [String]()
            }
            
            _in_ = column["$in"] as! [String]
            _nin_ = column["$nin"] as! [String]
            
            if data as? [CloudObject] != nil {
                _columnName = _columnName + "._id"
                var dataz = [String]()
                for (index, el) in data.enumerate() {
                    object.insert(el as! CloudObject, atIndex: index)
                    if let id = object[index].getId() {
                        dataz.append(id)
                    }else{
                        throw CloudBoostError.InvalidArgument
                    }
                }
                
                for (index, dat) in dataz.enumerate() {
                    if _nin_.indexOf(dat) == nil {
                        _nin_.append(dat)
                    }
                    if _in_.indexOf(dat) != nil {
                        _in_.removeAtIndex(index)
                    }
                }
                
            } else {
                for (index, dat) in data.enumerate() {
                    if _nin_.indexOf(dat.description) == nil {
                        _nin_.append(dat.description)
                    }
                    if _in_.indexOf(dat.description) != nil {
                        _in_.removeAtIndex(index)
                    }
                }
            }
            
            column["$in"] = _in_
            column["$nin"] = _nin_
            
            self.query[_columnName] = column
        } else {
            throw CloudBoostError.InvalidArgument
        }
        
        return self
    }
    
    public func notContainedIn(columnName: String, obj: [String]) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$nin":obj]
    }
    
    /**
     *
     * CloudQuery Exists
     *
     * @param columnName
     */
    public func exists(columnName: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$exists":true]
    }
    
    /**
     *
     * CloudQuery Does Not Exists
     *
     * @param columnName
     */
    public func doesNotExists(columnName: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$exists":false]
    }
    
    /**
     *
     * CloudQuery Include List
     *
     * @param columnName
     */
    public func includeList(columnName: String){
        var _columnName = columnName
        if columnName == "id" || columnName == "expires" {
            _columnName = "_" + columnName
        }
        self.includeList.append(_columnName)
        query["$includeList"] = self.includeList
    }
    
    /**
     *
     * CloudQuery Include
     *
     * @param columnName
     */
    public func include(columnName: String){
        var _columnName = columnName
        if columnName == "id" || columnName == "expires" {
            _columnName = "_" + columnName
        }
        self.include.append(_columnName)
        query["$include"] = self.include
    }

    public func sortAscendingBy(columnName: String) {
        var _columnName = columnName
        if(columnName == "id"){
        _columnName = "_id"
        }
        sort[_columnName] = 1
    }
    
    public func sortDescendingBy(columnName: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        sort[_columnName] = 1
    }
    
    public func near(columnName: String, geoPoint: CloudGeoPoint, maxDistance: Double, minDistance: Double){
        query[columnName] = nil
        query[columnName] = [ "$near" : [   "$geometry": [ "coordinates" : geoPoint.getCoordinates(), "type" : "Point"],
                                            "$maxDistance" : maxDistance,
                                            "$minDistance" : minDistance
                                        ]
                            ]
    }
    
    // query GeoPoint within an arrangement of Geo points
    public func geoWithin(columnName: String, geoPoints: [CloudGeoPoint]){
        query[columnName] = nil
        var coordinateList = [[Double]]()
        for geoPoint in geoPoints {
            coordinateList.append(geoPoint.getCoordinates())
        }
        coordinateList.append(geoPoints[0].getCoordinates())
        query[columnName] = [ "$geoWithin" : [ "$geometry": [ "coordinates" : [coordinateList], "type" : "Polygon"] ] ]
    }
    
    // within radius of a geo point
    public func geoWithin(columnName: String, geoPoint: CloudGeoPoint, radius: Double) {
        query[columnName] = nil
        query[columnName] = [ "$geoWithin" : [ "$centerSphere": [ geoPoint.getCoordinates(), radius/3963.2] ] ]
    }
    
    public func find(callback: (response: CloudBoostResponse)->Void) {
    
        let params = NSMutableDictionary()
        params["query"] = query
        params["select"] = select
        params["limit"] = limit
        params["skip"] = skip
        params["sort"] = sort
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + tableName! + "/find"
        
        CloudCommunications._request("POST",
                                     url: NSURL(string: url)!,
                                     params: params, callback: { response in

            if response.status == 200 {
                
                if let documents = response.object as? [NSDictionary] {
                    
                    var objectsArray = [CloudObject]()
                    
                    for document in documents {
                        
                        let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                        
                        objectsArray.append(object)
                    }
                    
                    let theResponse = CloudBoostResponse()
                    theResponse.success = response.success
                    theResponse.object = objectsArray
                    theResponse.status = response.status
                    
                    callback(response: theResponse)
                } else if let document = response.object as? NSMutableDictionary {
                    
                    let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                    
                    let theResponse = CloudBoostResponse()
                    theResponse.success = response.success
                    theResponse.object = object
                    theResponse.status = response.status
                    
                    callback(response: theResponse)
                } else {
                    
                    callback(response: response)
                }
            } else {
                
                callback(response: response)
            }
        })
    }
    
    public func findOne(callback: (response: CloudBoostResponse)->Void) throws {
        
        let params = NSMutableDictionary()
        params["query"] = query
        params["select"] = select
        params["skip"] = skip
        params["sort"] = sort
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + tableName! + "/findOne"
        
        CloudCommunications._request("POST",
                                     url: NSURL(string: url)!,
                                     params: params, callback: { response in
                                        
                                        if response.status == 200 {
                                            
                                            if let documents = response.object as? [NSMutableDictionary] {
                                                
                                                var objectsArray = [CloudObject]()
                                                
                                                for document in documents {
                                                    
                                                    let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                                                    
                                                    objectsArray.append(object)
                                                }
                                                
                                                let theResponse = CloudBoostResponse()
                                                theResponse.success = response.success
                                                theResponse.object = objectsArray
                                                theResponse.status = response.status
                                                
                                                callback(response: theResponse)
                                            } else if let document = response.object as? NSMutableDictionary {
                                                
                                                let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                                                
                                                let theResponse = CloudBoostResponse()
                                                theResponse.success = response.success
                                                theResponse.object = object
                                                theResponse.status = response.status
                                                
                                                callback(response: theResponse)
                                            } else {
                                                
                                                callback(response: response)
                                            }
                                        } else {
                                            
                                            callback(response: response)
                                        }
        })
        
    }
    
    public func findById(id: String, callback: (response: CloudBoostResponse) -> Void ){
        print("equatinf \(id)")
        try! self.equalTo("id", obj: id)
        
        let params = NSMutableDictionary()
        params["query"] = query
        params["select"] = select
        params["limit"] = 1
        params["skip"] = 0
        params["sort"] = sort
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + tableName! + "/find"
        
        CloudCommunications._request("POST",
                                     url: NSURL(string: url)!,
                                     params: params, callback: { response in
                                        
                                        if response.status == 200 {
                                            
                                            if let documents = response.object as? [NSMutableDictionary] {
                                                
                                                var objectsArray = [CloudObject]()
                                                
                                                for document in documents {
                                                    
                                                    let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                                                    
                                                    objectsArray.append(object)
                                                }
                                                
                                                let theResponse = CloudBoostResponse()
                                                theResponse.success = response.success
                                                theResponse.object = objectsArray
                                                theResponse.status = response.status
                                                
                                                callback(response: theResponse)
                                            } else if let document = response.object as? NSMutableDictionary {
                                                
                                                let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                                                
                                                let theResponse = CloudBoostResponse()
                                                theResponse.success = response.success
                                                theResponse.object = object
                                                theResponse.status = response.status
                                                
                                                callback(response: theResponse)
                                            } else {
                                                
                                                callback(response: response)
                                            }
                                        } else {
                                            
                                            callback(response: response)
                                        }
        })
    }

    public func distinct(key: String, callback: (response: CloudBoostResponse) -> Void ){
        
        var _key = key
        if(key == "id") {
            _key = "_id"
        }
        let params = NSMutableDictionary()
        params["onKey"] = _key
        params["query"] = query
        params["select"] = select
        params["limit"] = limit
        params["skip"] = 0
        params["sort"] = sort
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + tableName! + "/distinct"
        
        CloudCommunications._request("POST",
                                     url: NSURL(string: url)!,
                                     params: params, callback: { response in
                                        
                                        if response.status == 200 {
                                            
                                            if let documents = response.object as? [NSMutableDictionary] {
                                                
                                                var objectsArray = [CloudObject]()
                                                
                                                for document in documents {
                                                    
                                                    let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                                                    
                                                    objectsArray.append(object)
                                                }
                                                
                                                let theResponse = CloudBoostResponse()
                                                theResponse.success = response.success
                                                theResponse.object = objectsArray
                                                theResponse.status = response.status
                                                
                                                callback(response: theResponse)
                                            } else if let document = response.object as? NSMutableDictionary {
                                                
                                                let object = CloudObject.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                                                
                                                let theResponse = CloudBoostResponse()
                                                theResponse.success = response.success
                                                theResponse.object = object
                                                theResponse.status = response.status
                                                
                                                callback(response: theResponse)
                                            } else {
                                                
                                                callback(response: response)
                                            }
                                        } else {
                                            
                                            callback(response: response)
                                        }
        })
    }
    
    public func count( callbak: (response: CloudBoostResponse) -> Void ){
        
        let params = NSMutableDictionary()
        params["query"] = query
        params["limit"] = self.limit
        params["skip"] = 0
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + tableName! + "/count"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            callbak(response: response)
        })
    }


    public func paginate(_pageNo: Int?, _totalItemsInPage: Int?, callback: (objectsList: [NSDictionary]?, count: Int?, totalPages: Int?)->Void) {
        var pageNo: Int
        var totalItemsInPage: Int
        if let pno = _pageNo {
            pageNo = pno
        }else{
            pageNo = 1
        }
        if let total = _totalItemsInPage {
            totalItemsInPage = total
        }else{
            totalItemsInPage = limit
        }
        if pageNo > 0 && totalItemsInPage > 0 {
            let skip = pageNo*totalItemsInPage - totalItemsInPage
            self.setSkip(skip)
            self.setLimit(totalItemsInPage)
        } else if totalItemsInPage > 0 {
            self.setLimit(totalItemsInPage)
        }
        do {
            try self.find({
                response in
                if response.success {
                    self.setLimit(99999999)
                    self.setSkip(0)
                    let list = response.object as? [NSDictionary]
                    self.count({
                        response in
                        if response.success {
                            if let count = response.object as? Int {
                               callback(objectsList: list, count: count, totalPages: Int(ceil(Double(count)/Double(self.limit))) )
                            }
                        }else {
                            callback(objectsList: list, count: nil, totalPages: nil)
                        }
                    })
                } else {
                    callback(objectsList: nil,count: nil,totalPages: nil)
                }
            })
        } catch {
            callback(objectsList: nil,count: nil,totalPages: nil)
        }
    }
    
    public static func validateQuery(co: CloudObject, query: NSMutableDictionary) -> Bool {
        for (key, value) in query {
            if let key = key as? String{
                if key == "$include" || key == "$includeList" {
                    continue
                }
                if value as? NSMutableDictionary != nil || value as? [NSMutableDictionary] != nil {
                    // checking OR
                    if key == "$or" {
                        if let arr = query[key] as? [NSMutableDictionary] {
                            var valid = false
                            if arr.count > 0 {
                                for (_,val) in arr.enumerate() {
                                    if(CloudQuery.validateQuery(co, query: val)){
                                        valid = true
                                        break
                                    }
                                }
                                if valid == false {
                                    return false
                                }
                            }
                        }else{
                            return false
                        }
                    }
                    // here 'key' will usually contain the column name and value will be query
                    if let dictValue = value as? [String:AnyObject] {
                        // iterating over each query, $ne, $eq, etc
                        for (subKey, subValue) in dictValue {
                            
                            //not equalTo query
                            if subKey == "$ne" {
                                if co.get(key) === subValue {
                                    return false
                                }
                            }
                            
                            //greater than
                            if subKey == "$gt" {
                                if (co.get(key)as?Int) <= (subValue as? Int) {
                                    return false
                                }
                            }
                            
                            //less than
                            if subKey == "$lt" {
                                if (co.get(key)as?Int) >= (subValue as? Int) {
                                    return false
                                }
                            }
                            
                            //greater than and equalTo.
                            if subKey == "$gte" {
                                if (co.get(key)as?Int) < (subValue as? Int) {
                                    return false
                                }
                            }
                            
                            //less than and equalTo.
                            if subKey == "$lte" {
                                if (co.get(key)as?Int) > (subValue as? Int) {
                                    return false
                                }
                            }
                            
                            //exists
                            if subKey == "$exists" {
                                if let _ = co.get(key) {
                                    // do nothing since the object exists
                                }else{
                                    return false
                                }
                            }
                            
                            //startsWith.
                            if subKey == "$regex" {
                                if let re = subValue as? String {
                                    let reg = Regex(re)
                                    if let toMatch = co.get(key) as? String{
                                        return reg.test(toMatch)
                                    }
                                }
                                return false
                            }
                            
                            //containedIn
                            if subKey == "$in" {
                                if let arr = value[subKey] as? [AnyObject]{
                                    var value: AnyObject?
                                    if key.containsString(".") && co.get(key) == nil {
                                        if co.get(key.componentsSeparatedByString(".")[0]) != nil {
                                            value = co.get(key.componentsSeparatedByString(".")[0])
                                        }
                                    } else if co.get(key) != nil {
                                        value = co.get(key)
                                    }
                                    
                                    for el in arr {
                                        // return true on first occurance of 'value'
                                        if value === el {
                                           return true
                                        }
                                    }
                                }else{
                                    return false
                                }
                                return false
                            }
                            
                            //notContainedIn
                            if subKey == "$nin" {
                                if let arr = value[subKey] as? [AnyObject]{
                                    var value: AnyObject?
                                    if key.containsString(".") && co.get(key) == nil {
                                        if co.get(key.componentsSeparatedByString(".")[0]) != nil {
                                            value = co.get(key.componentsSeparatedByString(".")[0])
                                        }
                                    } else if co.get(key) != nil {
                                        value = co.get(key)
                                    }
                                    
                                    for el in arr {
                                        // return true on first occurance of 'value'
                                        if value === el {
                                            return false
                                        }
                                    }
                                }else{
                                    return true
                                }
                                return true
                            }

                            if subKey == "$all" {
                                
                            }
                            
                        
                        }
                    }
                } else {
                    // when the query sub-object corresponding to 'key' is not a JSONObect/JSONArray
                    
                }
            } // else dosent matter, if the key is not in a string format, then discard that query
        }
        return true
    }

}
