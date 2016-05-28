//
//  CloudRole.swift
//  CloudBoost
//
//  Created by Randhir Singh on 27/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudRole: CloudObject {
    
    // ACL, document and Modified columns are extended from CloudObject
    
    public init(roleName: String){
        super.init(tableName: "Role")
        
        _modifiedColumns.append("name")
        
        document["name"] = roleName
        document["_modifiedColumns"] = _modifiedColumns
        
    }
    
    required public init(tableName: String) {
        super.init(tableName: "Role")
    }
    
    
    // MARK:- Getter
    
    public func getName() -> String? {
        return document["name"] as? String
    }
    
    // MARK:- Setter
    
    public func setName(name: String) {
        document["name"] = name
        _modifiedColumns.append("name")
    }
    
    // MARK:- Cloud Operations on CloudObject
    
    
    // Save the CloudObject on CLoudBoost.io
    public override func save(callback: (CloudBoostResponse) -> Void ){
        let url = CloudApp.serverUrl + "/data/" + CloudApp.appID! + "/"
            + (self.document["_tableName"] as! String)
        let params = NSMutableDictionary()
        params["key"] = CloudApp.appKey!
        params["document"] = document
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback:
            {(response: CloudBoostResponse) in
                if(response.success){
                    if let newDocument = response.object {
                        self.document = newDocument as! NSMutableDictionary
                    }
                }
                callback(response)
        })
    }
    
    
    //Deleting all rows
    public override func delete( callback: (CloudBoostResponse) -> Void ){
        let url = CloudApp.serverUrl + "/data/" + CloudApp.appID! + "/"
            + (self.document["_tableName"] as! String);
        let params = NSMutableDictionary()
        params["key"] = CloudApp.appKey!
        params["document"] = document
        
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback:
            {(response: CloudBoostResponse) in
                callback(response)
        })
    }
    
    
    
}