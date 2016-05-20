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
    
    required public init(tableName: String){
        self._modifiedColumns = [String]()
        
        _modifiedColumns.append("createdAt")
        _modifiedColumns.append("updatedAt")
        _modifiedColumns.append("ACL")
        _modifiedColumns.append("expires")
        
        document["_id"] = ""
        document["ACL"] = acl.getACL()
        document["_tableName"] = tableName
        if(tableName == "Role"){
            document["_type"] = "role"
        }else if (tableName == "User"){
            document["_type"] = "user"
        }else{
            document["_type"] = "custom"
        }
        document["createdAt"] = ""
        document["updatedAt"] = ""
        document["_modifiedColumns"] = _modifiedColumns
        document["_isModified"] = true
        
    }
    
    // MARK:- Setter Functions
    
    // Set an object(assument that it can be serialised
    public func set(attribute: String, value: AnyObject) -> (Int, String?) {
        let keywords = ["_tableName", "_type","operator","_id","createdAt","updatedAt"]
        if(keywords.indexOf(attribute) != nil){
            //Not allowed to chage these values
            return(-1,"Not allowed to change these values")
        }
        // Cloud Object
        if let obj = value as? CloudObject {
            document[attribute] = obj.document
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
            // Cloud Object List
        else if let obj = value as? [CloudObject] {
            var res = [NSMutableDictionary]()
            for o in obj {
                res.append(o.document)
            }
            document[attribute] = res
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
            // Geo point
        else if let obj = value as? CloudGeoPoint {
            document[attribute] = obj.document
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
            // Geo point list
        else if let obj = value as? [CloudGeoPoint] {
            var res = [NSMutableDictionary]()
            for o in obj {
                res.append(o.document)
            }
            document[attribute] = res
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
            // Cloud File
        else if let obj = value as? CloudFile {
            document[attribute] = obj.document
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
            // Cloud file list
        else if let obj = value as? [CloudFile] {
            var res = [NSMutableDictionary]()
            for o in obj {
                res.append(o.document)
            }
            document[attribute] = res
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
            // Date
        else if let obj = value as? NSDate {
            document[attribute] = CloudBoostDateFormatter.getISOFormatter().stringFromDate(obj)
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
            
        else {
            document[attribute] = value
            _modifiedColumns.append(attribute)
            document["_modifiedColumns"] = _modifiedColumns
        }
        return(1,nil)
    }
    
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
    
    // Set a date value
    public func setDate(attribute: String, value: NSDate) -> (Int, String?) {
        let keywords = ["_tableName", "_type","operator","_id","createdAt","updatedAt"]
        if(keywords.indexOf(attribute) != nil){
            //Not allowed to chage these values
            return(-1,"Not allowed to change these values")
        }
        // Converting the date to a standard date string format
        document[attribute] = CloudBoostDateFormatter.getISOFormatter().stringFromDate(value)
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
    public func getAcl() -> ACL? {
        if let aclDoc = document["ACL"] as? NSMutableDictionary {
            return ACL(acl: aclDoc)
        }
        return nil
    }
    
    // set ACL of the object
    public func setACL(acl: ACL) {
        _modifiedColumns.append("ACL")
        document["ACL"] = acl.getACL()
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
    
    // Get a date attribute
    public func getDate(attribute: String) -> NSDate? {
        if let attribute = document[attribute] as? String {
            return CloudBoostDateFormatter.getISOFormatter().dateFromString(attribute)
        }
        return nil
    }
    
    // Get a GeoPoint
    public func getGeoPoint(attribute: String) -> CloudGeoPoint? {
        if let geoPoint = document[attribute] as? NSDictionary {
            do {
                let geoPointObj = try CloudGeoPoint(latitude: geoPoint["latitude"] as! Double, longitude: geoPoint["longitude"] as! Double)
                return geoPointObj
            } catch {
                return nil
            }
        }
        return nil
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
                            object.document = newDocument as! NSMutableDictionary
                        }
                    }else{
                        resp.success = false
                        resp.message = "one or more objects were not saved"
                    }
                    if(count == array.count){
                        resp.object = count
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
    
    public static func on(tableName: String, eventType: String, handler: ([CloudObject]?)->Void, callback: (error: String?)->Void){
        let tableName = tableName.lowercaseString
        let eventType = eventType.lowercaseString
        if CloudApp.SESSION_ID == nil {
            callback(error: "Invalid session ID")
        }else{
            print("Using session ID: \(CloudApp.SESSION_ID)")
        }
        if eventType == "created" || eventType == "deleted" || eventType == "updated" {
            let str = (CloudApp.getAppId()! + "table" + tableName + eventType).lowercaseString
            let payload = NSMutableDictionary()
            payload["room"] = str
            
            CloudSocket.getSocket().on(str, callback: {
                data, ack in
                var resArr = [CloudObject]()
                for el in data {
                    if let doc = el as? NSMutableDictionary {
                        let obj = CloudObject(tableName: tableName)
                        obj.document = doc
                        resArr.append(obj)
                    }
                }
                handler(resArr)
            })
            CloudSocket.getSocket().on("connect", callback: { data, ack in
                print("sessionID: \(CloudSocket.getSocket().sid)")
                payload["sessionId"] = CloudSocket.getSocket().sid
                CloudSocket.getSocket().emit("join-object-channel", payload)
                callback(error: nil)
            })
            CloudSocket.getSocket().connect(timeoutAfter: 15, withTimeoutHandler: {
                print("Timeout")
                callback(error: "Timed out")
            })
            
            
            
        } else {
            callback(error: "invalid event type, it can only be (created, deleted, updated)")
        }
    }
    
    public static func on(tableName: String, eventTypes: [String], handler: ([CloudObject]?)->Void, callback: (error: String?)->Void){
        let tableName = tableName.lowercaseString
        if CloudApp.SESSION_ID == nil {
            callback(error: "Invalid session ID")
        }else{
            print("Using session ID: \(CloudApp.SESSION_ID)")
        }
        var payloads = [NSMutableDictionary]()
        
        for (index,event) in eventTypes.enumerate() {
            if event == "created" || event == "deleted" || event == "updated" {
                let str = (CloudApp.getAppId()! + "table" + tableName + event).lowercaseString
                payloads.insert([:], atIndex: index)
                payloads[index]["room"] = str
                CloudSocket.getSocket().on(str, callback: {
                    data, ack in
                    var resArr = [CloudObject]()
                    for el in data {
                        if let doc = el as? NSMutableDictionary {
                            let obj = CloudObject(tableName: tableName)
                            obj.document = doc
                            resArr.append(obj)
                        }
                    }
                    handler(resArr)
                })
            }else{
                callback(error: "invalid event type, it can only be (created, deleted, updated)")
                return
            }
        }
        CloudSocket.getSocket().on("connect", callback: { data, ack in
            print("sessionID: \(CloudSocket.getSocket().sid)")
            for (index,_) in payloads.enumerate() {
                payloads[index]["sessionId"] = CloudSocket.getSocket().sid
                CloudSocket.getSocket().emit("join-object-channel", payloads[index])
            }
            callback(error: nil)
        })
        CloudSocket.getSocket().connect(timeoutAfter: 15, withTimeoutHandler: {
            print("Timeout")
            callback(error: "Timed out")
        })
        
    }
    
    /**
     * start listening to events
     * @param tableName table to listen to events from
     * @param eventType one of created, deleted, updated
     * @param cloudQuery filter to apply on the data
     * @param handler
     * @param callback
     */
    public static func on(tableName: String, eventType: String, query: CloudQuery, handler: ([CloudObject]?)->Void, callback: (error: String?)->Void){
        let eventType = eventType.lowercaseString
        if query.getTableName() != tableName {
            print(query.getTableName())
            print(tableName)
            callback(error: "CloudQuery TableName and CloudNotification TableName should be same")
            return
        }
        // if select not equal to an empty mutable dictionary
        if query.getSelect() != NSMutableDictionary() {
            callback(error: "You cannot pass the query with select in CloudNotifications")
            return
        }
        var countLimit = query.getLimit()
        if eventType == "created" || eventType == "deleted" || eventType == "updated" {
            let str = (CloudApp.getAppId()! + "table" + tableName + eventType).lowercaseString
            let payload = NSMutableDictionary()
            payload["room"] = str
            
            CloudSocket.getSocket().on(str, callback: {
                data, ack in
                var resArr = [CloudObject]()
                for el in data {
                    if let doc = el as? NSMutableDictionary {
                        let obj = CloudObject(tableName: tableName)
                        obj.document = doc
                        if CloudObject.validateNotificationQuery(obj, query: query) && countLimit != 0 {
                            countLimit -= 1
                            resArr.append(obj)
                        }
                    }
                }
                if resArr.count > 0{
                    handler(resArr)
                }
            })
            CloudSocket.getSocket().on("connect", callback: { data, ack in
                print("sessionID: \(CloudSocket.getSocket().sid)")
                payload["sessionId"] = CloudSocket.getSocket().sid
                CloudSocket.getSocket().emit("join-object-channel", payload)
                callback(error: nil)
            })
            CloudSocket.getSocket().connect(timeoutAfter: 15, withTimeoutHandler: {
                print("Timeout")
                callback(error: "Timed out")
            })
            
            
            
        } else {
            callback(error: "invalid event type, it can only be (created, deleted, updated)")
        }
    }
    
    
    public static func off(tableName: String, eventType: String, callback: (error: String?)->Void){
        let tableName = tableName.lowercaseString
        let eventType = eventType.lowercaseString
        if eventType == "created" || eventType == "deleted" || eventType == "updated" {
            let str = (CloudApp.getAppId()! + "table" + tableName + eventType).lowercaseString
            
            CloudSocket.getSocket().emit("leave-object-channel", str)
            CloudSocket.getSocket().on(str, callback: {_,_ in})
            
            
        } else {
            callback(error: "invalid event type, it can only be (created, deleted, updated)")
        }
    }
    
    private static func validateNotificationQuery(object: CloudObject, query: CloudQuery) -> Bool {
        var valid = false
        
        // if query is equal to empty dictionary
        if query.getQuery() == NSMutableDictionary(){
            return valid
        }
        if query.getLimit() == 0 {
            return valid
        }
        if query.getSkip() > 0 {
            query.setSkip((query.getSkip())-1)
            return valid
        }
        let realQuery = query.getQuery()
        realQuery["$include"] = nil
        realQuery["$all"] = nil
        realQuery["$includeList"] = nil
        valid = CloudQuery.validateQuery(object, query: realQuery)
        
        return valid
    }
    
    
}