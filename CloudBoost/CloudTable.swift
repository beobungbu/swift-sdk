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
    private var attributes: NSMutableDictionary?
    private var document = NSMutableDictionary()
    
    public init(tableName: String, attributes: NSMutableDictionary){
        self.tableName = tableName
        self.attributes = attributes
        document["name"] = tableName
        document["appId"] = CloudApp.appID
        document["type"] = "custom"
        document["maxCount"] = 9999
        document["columns"] = attributes
    }
    
    public func getDocument(){
        
    }
    public func save(callback: (CloudBoostResponse) -> Void){
        print("Yes! Saving " + tableName! + "...")
        let url = CloudApp.serverUrl + "/app/" + CloudApp.appID! + "/" + tableName!
        let params = NSMutableDictionary()
        params["key"] = CloudApp.appKey!
        params["data"] = attributes
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            // Callback from _request, route it to save() callback
            callback(response)
        })
    }
}