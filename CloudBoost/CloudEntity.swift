//
//  CloudTable.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudEntity {
    
    public var entityName: String?
    public var attributes: NSMutableDictionary?
    
    public init(entityName: String, attributes: NSMutableDictionary){
        self.entityName = entityName
        self.attributes = attributes
    }
    
    public func save(callback: Helper.callback){
        print("Yes! Saving " + entityName! + "...")
        let url = CloudApp.serverUrl + "/data/" + CloudApp.appID! + "/" + entityName!
        let params = [ "key":CloudApp.appKey! ] as NSMutableDictionary
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            (status: Int, message: String) -> Void in
            // Do saveTable level error reporting
            callback(status: status, message: message)
        })

    }
}