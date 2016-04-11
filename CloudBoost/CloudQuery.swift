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
    
    // constructor
    public init(tableName: String){
        
        self.tableName = tableName
        
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
    
    
    public func equalTo(columnName: String, obj: AnyObject) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = obj
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
    }
    
    public func notEqualTo(columnName: String, obj: AnyObject) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
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
    
    public func notContainedIn(columnName: String, obj: [String]) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$nin":obj]
    }
    
    public func exists(columnName: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$exists":true]
    }
    
    public func doesNotExists(columnName: String) {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$exists":false]
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
    
//    public func substring(columnName: String, subStrs: [String]) throws {
//        var _columnName = columnName
//        if(columnName == "id"){
//            _columnName = "_id"
//        }
////        var exp = [NSMutableDictionary]()
//        for str in subStrs {
//            let tempQ = CloudQuery(tableName: self.getTableName()!)
//            try! tempQ.substring(columnName, subStr: str)
////            tempQ.query[_columnName] = ["$regex" : ".*" + str + ".*" ]
//            do {
//                try or(self, object2: tempQ)
//            } catch {
//                throw CloudBoostError.InvalidArgument
//            }
//            
//        }
////        query[_columnName] = exp
//        guard let _ = try query.getJSON() else{
//            throw CloudBoostError.InvalidArgument
//        }
//    }
    
    
    public func find(callbak: (response: CloudBoostResponse)->Void) throws {
        let params = NSMutableDictionary()
        params["query"] = query
        params["select"] = select
        params["limit"] = limit
        params["skip"] = skip
        params["sort"] = sort
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + tableName! + "/find"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            callbak(response: response)
        })
        
    }
    
    public func findOne(callbak: (response: CloudBoostResponse)->Void) throws {
        let params = NSMutableDictionary()
        params["query"] = query
        params["select"] = select
        params["skip"] = skip
        params["sort"] = sort
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + tableName! + "/findOne"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            callbak(response: response)
        })
        
    }
    
    public func findById(id: String, callbak: (response: CloudBoostResponse) -> Void ){
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
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            callbak(response: response)
        })
    }

    public func distinct(key: String, callbak: (response: CloudBoostResponse) -> Void ){
        
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
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            callbak(response: response)
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


    public func paginate(pageNo: Int, totalItemsInPage: Int, callback: (objectsList: [NSDictionary]?, count: Int?, totalPages: Int?)->Void) {
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
                        }
                        callback(objectsList: list, count: nil, totalPages: nil)
                    })
                } else {
                    callback(objectsList: nil,count: nil,totalPages: nil)
                }
            })
        } catch {
            callback(objectsList: nil,count: nil,totalPages: nil)
        }
    }

}
