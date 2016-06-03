//
//  CloudPush.swift
//  CloudBoost
//
//  Created by Randhir Singh on 14/05/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudPush {
    
    public static func send(data: AnyObject, query: CloudQuery?, callback: (CloudBoostResponse)->Void) throws {
        
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.AppIdNotSet
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.AppIdNotSet
        }
        var pushQuery: CloudQuery
        if query == nil {
            pushQuery = CloudQuery(tableName: "Device")
        }else{
            pushQuery = query!
        }
        
        let params = NSMutableDictionary()

        params["query"] = pushQuery.getQuery()
        params["sort"] = pushQuery.getSort()
        params["limit"] = pushQuery.getLimit()
        params["skip"] = pushQuery.getSkip()
        
        params["key"] = CloudApp.getAppKey()
        params["data"] = data
        
        let url = CloudApp.getApiUrl() + "/push/" + CloudApp.getAppId()! + "/send"
        
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {response in
            print("Response !!")
            callback(response)
        })
        
    }
    
    
}