//
//  CloudObject.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudObject{
    var acl = NSMutableDictionary()
    var document = NSMutableDictionary()
    var _modifiedColumns = [String]()
    
    public init(name: String){
        self._modifiedColumns = [String]()
        
        _modifiedColumns.append("createdAt")
        _modifiedColumns.append("updatedAt")
        _modifiedColumns.append("ACL")
        _modifiedColumns.append("expires")
        
        document["_id"] = ""
        document["ACL"] = acl
        document["_tableName"] = name
        document["_type"] = "custom"
        document["createdAt"] = ""
        document["updatedAt"] = ""
        document["_modifiedColumns"] = _modifiedColumns
        document["_isModified"] = true
        
    }
    
    
    public func set(attribute: String, value: String){
        let keywords = ["_tableName", "_type","operator"]
        if(keywords.indexOf(attribute) != nil){
            //Not allowed to chage these values
        }
    }
    
    public func get(attribute: String) -> AnyObject? {
        return document[attribute]
    }
    
    public func getInt(attribute: String) -> Int? {
        return document[attribute] as? Int
    }
    
    public func getString(attribute: String) -> String? {
        return document[attribute] as? String
    }
    
    public func getBoolean(attribute: String) -> Bool? {
        return document[attribute] as? Bool
    }
    
    public func log() {
        print("\n---CloudBoost Object---");
    }
    
    public func save(callback: (status: Int, object: String) -> Void){
        let url = CloudApp.serverUrl + "/data/" + CloudApp.appID! + "/"
            + (self.document["_tableName"] as! String);
        let params = NSMutableDictionary()
        params["key"] = CloudApp.appKey!
        params["document"] = document
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback:
            {(status: Int, object: String) -> Void in
                callback(status: status,object: object)
        })
        
    }
    
}