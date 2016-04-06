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
    
    public func getTableName() -> String?{
        return tableName
    }
    
    public func setTableName(tableName: String) {
        self.tableName = tableName
    }
    
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
    
    public func substring(columnName: String, subStr: String) throws {
        var _columnName = columnName
        if(columnName == "id"){
            _columnName = "_id"
        }
        query[_columnName] = ["$regex": ".*" + subStr + ".*"]
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
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
        params["limit"] = 1
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


    

}
