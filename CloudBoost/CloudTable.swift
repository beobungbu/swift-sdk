//
//  CloudTable.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudTable {
    
    public var tableName: String?
    private var columns = [NSMutableDictionary]()
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
    
    // MARK:- Setter functions
    public func setColumn(columnName: Column){
        columns.append(columnName.document)
        document["columns"] = columns
    }
    
    public func addColumn(columnName: Column){
        columns.append(columnName.document)
        document["columns"] = columns
    }
    
    // MARK:- Getter functions
    
    
    
    // MARK:- Cloud operations on CloudTable
    
    public func save(callback: (CloudBoostResponse) -> Void){
        let url = CloudApp.serverUrl + "/app/" + CloudApp.appID! + "/" + tableName!
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey!
        params["data"] = document
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            // Callback from _request, route it to save() callback
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
    
}