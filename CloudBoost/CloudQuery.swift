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

    var query = NSMutableDictionary()
    var select = NSMutableDictionary()
    var sort = NSMutableDictionary()
    let body = NSMutableDictionary()
    
    var include = [String]()
    var includeList = [String]()

    var _include = [String]()
    var _includeList = [String]()
    
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
    
    
    public func equalTo(var columnName: String, obj: AnyObject) throws {
        if(columnName == "id"){
            columnName = "_id"
        }
        query[columnName] = obj
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
    }
    
    public func lessThan(var columnName: String, obj: AnyObject) throws {
        if(columnName == "id"){
            columnName = "_id"
        }
        query[columnName] = ["$lt":obj]
        guard let _ = try query.getJSON() else{
            throw CloudBoostError.InvalidArgument
        }
    }
    
    
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



    

}
