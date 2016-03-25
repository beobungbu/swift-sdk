//
//  CloudObject.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudObject{
    var acl = ACL()
    var document = NSMutableDictionary()
    var _modifiedColumns = [String]()
    
    public init(name: String){
        self._modifiedColumns = [String]()
        
        _modifiedColumns.append("createdAt")
        _modifiedColumns.append("updatedAt")
        _modifiedColumns.append("ACL")
        
        document["_id"] = ""
        document["ACL"] = acl.getACL()
        document["_tableName"] = name
        document["_type"] = "custom"
        document["createdAt"] = ""
        document["updatedAt"] = ""
        document["_modifiedColumns"] = _modifiedColumns
        document["_isModified"] = true
        
    }
    
    // MARK:- Setter Functions
    
    // Set a string  value in the CloudObject
    public func setString(attribute: String, value: String) -> (Int, String?){
        let keywords = ["_tableName", "_type","operator","_id","createdAt","updatedAt"]
        if(keywords.indexOf(attribute) != nil){
            //Not allowed to chage these values
            return(-1,"Not allowed to change these values")
        }
        document[attribute] = value
        _modifiedColumns.append(attribute)
        document["_modifiedColumns"] = _modifiedColumns
        return(1,nil)
    }
    
    // Set an integer value in the CloudObject
    public func setInt(attribute: String, value: Int) -> (Int, String?){
        let keywords = ["_tableName", "_type","operator","_id","createdAt","updatedAt"]
        if(keywords.indexOf(attribute) != nil){
            //Not allowed to chage these values
            return(-1,"Not allowed to change these values")
        }
        document[attribute] = value
        _modifiedColumns.append(attribute)
        document["_modifiedColumns"] = _modifiedColumns
        return(1,nil)
    }
    
    
    // Should this object appear in searches
    public func setIsSearchable(value: Bool){
        document["_isSearchable"] = value
        _modifiedColumns.append("_isSearchable")
    }
    
    // Set expiry time for this cloudobject, after which it will not appear in queries and searches
    public func setExpires(value: NSDate){
        document["expires"] = value.description
    }
    
    
    
    // MARK:- Getter functions

    // Get a unique ID of the object, needs to be saved first
    public func getId() -> String? {
        if let id = document["_id"] as? String {
            if(id  == ""){
                return nil
            }else{
                return id
            }
        }
        return nil
    }
    
    // Get the ACL property associated with the object
    public func getAcl() -> NSMutableDictionary? {
        // FIgure out ACL
        return nil
    }
    
    // Checks if the object has the kay
    func exist(key: String) -> Bool{
        if(document[key] != nil){
            return true
        }
        return false
    }
    
    // Get when this cloudobject will expire
    public func getExpires() -> NSDate? {
        // Parse as NSDate
        return document["expires"] as? NSDate
    }
    
    // Gets the creation date of this Object
    public func getCreatedAt() -> NSDate? {
        // Implement parsing logic
        
        return document["createdAt"] as? NSDate
    }
    
    // Gets the last update date of this object
    public func getUpdatedAt() -> NSDate? {
        // Implement parsing logic
        
        return document["updatedAt"] as? NSDate
    }
    

    // Get any attribute as AnyObject
    public func get(attribute: String) -> AnyObject? {
        return document[attribute]
    }
    
    // return true if search can be performed on the object
    public func getIsSearchable() -> Bool? {
        return document["_isSearchable"] as? Bool
    }
    
    // Get an integer attribute
    public func getInt(attribute: String) -> Int? {
        return document[attribute] as? Int
    }
    
    // Get a string attribute
    public func getString(attribute: String) -> String? {
        return document[attribute] as? String
    }
    
    // Get a boolean attribute
    public func getBoolean(attribute: String) -> Bool? {
        return document[attribute] as? Bool
    }
    
    // Log this cloud boost object
    public func log() {
        print("-- CLoud Object --")
        print(document)        
    }
    
    
    // MARK:- Cloud Operations on CloudObject
    
    
    // Save the CloudObject on CLoudBoost.io
    public func save(callback: (CloudBoostResponse) -> Void ){
        let url = CloudApp.serverUrl + "/data/" + CloudApp.appID! + "/"
            + (self.document["_tableName"] as! String);
        let params = NSMutableDictionary()
        params["key"] = CloudApp.appKey!
        params["document"] = document
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback:
            {(response: CloudBoostResponse) in
                if(response.success){
                    if let newDocument = response.object {
                        self.document = newDocument
                    }
                }
                callback(response)
        })
    }
    
    
    //Deleting all rows
    public func delete( callback: (CloudBoostResponse) -> Void ){
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
    
    
    
    
    // Save an array of CloudObject
    public static func saveAll(array: [CloudObject], callback: (CloudBoostResponse)->Void) {
        
        // Ready the response
        let resp = CloudBoostResponse()
        resp.success = true
        var count = 0
        
        // Iterate through the array
        for object in array {
            let url = CloudApp.serverUrl + "/data/" + CloudApp.appID! + "/"
                + (object.document["_tableName"] as! String);
            let params = NSMutableDictionary()
            params["key"] = CloudApp.appKey!
            params["document"] = object.document
            
            CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback:
                {(response: CloudBoostResponse) in
                    count += 1
                    if(response.success){
                        if let newDocument = response.object {
                            object.document = newDocument
                        }
                    }else{
                        resp.success = false
                        resp.message = "one or more objects were not saved"
                    }
                    if(count == array.count){
                        callback(resp)
                    }
            })
        }
    }

    // Delete an array of CloudObject
    public static func deleteAll(array: [CloudObject], callback: (CloudBoostResponse)->Void) {
        
        // Ready the response
        let resp = CloudBoostResponse()
        resp.success = true
        var count = 0
        
        // Iterate through the array
        for object in array {
            let url = CloudApp.serverUrl + "/data/" + CloudApp.appID! + "/"
                + (object.document["_tableName"] as! String);
            let params = NSMutableDictionary()
            params["key"] = CloudApp.appKey!
            params["document"] = object.document
            
            CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback:
                {(response: CloudBoostResponse) in
                    count += 1
                    if(!response.success){
                        resp.success = false
                        resp.message = "one or more objects were not deleted"
                    }
                    if(count == array.count){
                        callback(resp)
                    }
            })
        }
    }

    
}