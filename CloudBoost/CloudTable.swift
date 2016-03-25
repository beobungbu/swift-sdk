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
    private var columns = [String]()
    private var document = NSMutableDictionary()
    
    public init(tableName: String){
        self.tableName = tableName
        document["name"] = tableName
        document["appId"] = CloudApp.appID
        document["type"] = "custom"
        document["maxCount"] = 9999
        document["columns"] = columns
    }
    
    // MARK:- Setter functions
    public func setColumn(columnName: String){
        if(columns.indexOf(columnName) != -1){
            columns.append(columnName)
            document["columns"] = columns
        }
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
        let url = CloudApp.serverUrl + "/app/" + CloudApp.appID! + "/_getALL"
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey!
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            // Callback from _request, route it to save() callback
            callback(response)
        })

    }
    
}