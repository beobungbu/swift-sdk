//
//  CloudTable.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudTable {
    
    public var tableName: String
    public var columns = [NSMutableDictionary]()
    var document = NSMutableDictionary()
    
    public init(tableName: String){
        self.tableName = tableName
        document["name"] = tableName
        document["appId"] = CloudApp.appID
        document["type"] = "custom"
        document["maxCount"] = 9999
        self.columns = Column._defaultColumns("custom")
        document["columns"] = columns
    }
    
    // MARK:- Setter and getter functions
    public func setColumn(columnName: Column){
        columns.append(columnName.document)
        document["columns"] = columns
    }
    
    public func setTableType(columnType: String){
        document["type"] = columnType
    }

    
    public func addColumn(columnName: Column){
        columns.append(columnName.document)
        document["columns"] = columns
    }
    
    public func setTableName(tableName: String) {
        self.document["name"] = tableName
    }
    
    public func updateColumn(column: Column) throws {
        for (index,el) in columns.enumerate() {
            if let elName = el["name"] as? String {
                if elName == column.getColumnName() {
                    columns[index] = column.document
                    return
                }
            }
        }
        throw CloudBoostError.DoesNotExist
    }
    
    
    public func getTableName() -> String? {
        return self.document["name"] as? String
    }
    
    public func getTableType() -> String? {
        return document["type"] as? String
    }
    
    public func getID() -> String? {
        return self.document["_id"] as? String
    }
    
    
    
    
    // MARK:- Cloud operations on CloudTable
    
    public func save(callback: (CloudBoostResponse) -> Void){
        // set table with updated columns, if any
        document["columns"] = columns
        
        let url = CloudApp.serverUrl + "/app/" + CloudApp.appID! + "/" + tableName
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey!
        params["data"] = document
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            // Callback from _request, route it to save() callback
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                    if let cols = doc["columns"] as? [NSMutableDictionary] {
                        self.columns = cols
                    }
                }
            }
            callback(response)
        })
    }
    
    public static func getAll(callback: (CloudBoostResponse) -> Void) {
        let url = CloudApp.getApiUrl() + "/app/" + CloudApp.appID! + "/_getALL"
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey!
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            // Callback from _request, route it to save() callback
            callback(response)
        })

    }
    
    public static func get(table: CloudTable, callback: (CloudBoostResponse, CloudTable?) -> Void) {
        let url = CloudApp.getApiUrl() + "/app/" + CloudApp.appID! + "/" + table.getTableName()!
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey!
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            // Callback from _request, route it to save() callback
            if response.success && response.status == 200 {
                let returnTable = table
                if let doc = (response.object as? NSMutableDictionary) {
                    returnTable.document = doc
                    if let cols = doc["columns"] as? [NSMutableDictionary] {
                        returnTable.columns = cols
                    }
                }
                callback(response, returnTable)
            }else{
                callback(response, nil)
            }
        })
        
    }
    
    public func delete(callback: (CloudBoostResponse) -> Void) throws{
        if self.getID() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let url = CloudApp.serverUrl + "/app/" + CloudApp.appID! + "/" + self.getTableName()!
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey!
        params["name"] = self.getTableName()
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            // Callback from _request, route it to save() callback
            callback(response)
        })
    }
    
}