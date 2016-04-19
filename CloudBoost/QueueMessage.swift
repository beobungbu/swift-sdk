//
//  QueueMessage.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class QueueMessage {
    private var acl = ACL()
    private var timeout = 1800
    private var message: String?
    private var document = NSMutableDictionary()
    private var _modifiedColumns = [String]()
    private var type = "queue-message"
    
    // Public constructor
    public init(){
        _modifiedColumns.append("createdAt")
        _modifiedColumns.append("updatedAt")
        _modifiedColumns.append("ACL")
        _modifiedColumns.append("expires")
        _modifiedColumns.append("timeout")
        _modifiedColumns.append("delay")
        _modifiedColumns.append("message")
        
        document["_id"] = nil
        document["timeout"] = timeout
        document["delay"] = nil
        document["_type"] = type
        document["ACL"] = acl.getACL()
        document["expires"] = nil
        document["_modifiedColumns"] = _modifiedColumns
        document["_isModified"] = true
        document["message"] = message
        
    }
    
    public func hasKey(key: String) -> Bool {
        if let _ = document[key] {
            return true
        }else{
            return false
        }
    }
    
    public func getId() -> String? {
        if let id = getElement("_id") as? String {
            return id
        }
        return nil
    }
    
    
    // MERK: Setters and getters
    
    public func setExpires(date: NSDate){
        addElement("expires", val: CloudBoostDateFormatter.getISOFormatter().stringFromDate(date))
    }
    
    public func getExpires() -> NSDate? {
        if let strDate = document["expires"] as? String {
            let date = CloudBoostDateFormatter.getISOFormatter().dateFromString(strDate)
            return date
        }
        return nil
    }
    
    public func setDelay(delay: AnyObject) {
        addElement("delay", val: delay)
    }
    
    public func push(message: String) {
        self.message = message
        addElement("message", val: message)
    }
    
    public func setMessage(message: String) {
        self.message = message
        addElement("message", val: message)
    }
    
    public func getMessage() -> String? {
        if let str = document["message"] as? String {
            return str
        }
        return nil
    }
    
    public func setACL(acl: ACL) {
        addElement("ACL", val: acl.getACL())
    }
    
    public func getACL() -> ACL? {
        if let acl = document["ACL"] as? NSMutableDictionary {
            let returnACL = ACL(acl: acl)
            return returnACL
        }
        return nil
    }
    
    public func getTimeout() -> Int? {
        if let timeout = document["timeout"] as? Int {
            return timeout
        }
        return nil
    }
    
    public func setTimeout(timeout: Int) {
        addElement("timeout", val: timeout)
    }
    
    public func setType(type: String) {
        addElement("type", val: type)
    }
    
    public func getType() -> String? {
        if let type = document["type"] as? String {
            return type
        }
        return nil
    }
    
    public func getDocument() -> NSMutableDictionary{
        return self.document
    }
    
    public func setDocument(document: NSMutableDictionary) {
        self.document = document
    }
    
    // MARK: private helper functions
    
    private func addElement(key: String, val: AnyObject){
        document[key] = val
        _modifiedColumns.append(key)
        document["_modifiedColumns"] = _modifiedColumns
    }
    
    private func getElement(key: String) -> AnyObject? {
        return document[key]
    }
    
}