//
//  CloudPush.swift
//  CloudBoost
//
//  Created by Randhir Singh on 14/05/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudPush {
    
    public static func send(data: AnyObject, query: CloudQuery, callback: (CloudBoostResponse)->Void) throws {
        let tableName = "Device"
        
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.AppIdNotSet
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.AppIdNotSet
        }
        
        let params = NSMutableDictionary()
        params["query"] = query.getQuery()
        params["sort"] = query.getSort()
        params["limit"] = query.getLimit()
        params["skip"] = query.getSkip()
        params["key"] = CloudApp.getAppKey()
        params["data"] = data
        
        let url = CloudApp.getApiUrl() + "/push/" + CloudApp.getAppId()! + "/send"
        
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {response in
            
            callback(response)
        })
        
    }
    
    
}