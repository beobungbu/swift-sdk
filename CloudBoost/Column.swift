//
//  Column.swift
//  CloudBoost
//
//  Created by Randhir Singh on 25/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class Column {
    public var document = NSMutableDictionary()
    
    public init(name: String, dataType: CloudBoostDataType){
        document["name"] = name
        document["dataType"] = dataType.rawValue
        document["type"] = "column"
        document["required"] = false
        document["unique"] = false
        document["isDeletable"] = true
        document["isEditable"] = true
        document["isRenamable"] = false
    }
    
    public init(name: String, dataType: CloudBoostDataType, required: Bool, unique: Bool){
        document["name"] = name
        document["dataType"] = dataType.rawValue
        document["type"] = "column"
        document["required"] = required
        document["unique"] = unique
        document["isDeletable"] = true
        document["isEditable"] = true
        document["isRenamable"] = false
    }
    
    // MARK:- Setters
    
    public func setIsDeletable(value: Bool){
        document["isDeletable"] = value
    }
    
    public func setIsEditable(value: Bool){
        document["isEditable"] = value
    }
    
    public func setIsRenamable(value: Bool){
        document["isRenamable"] = value
    }
    
    public func setColumnName(value: String){
        document["name"] = value
    }
    
    public func setRequired(value: Bool){
        document["required"] = value
    }
    
    public func setUnique(value: Bool){
        document["unique"] = value
    }
    
    public func setDataType(dataType: CloudBoostDataType){
        document["dataType"] = dataType.rawValue
    }
    
    // MARK:- Getter
    
    public func getColumnName() -> String? {
        return document["name"] as? String
    }
    
    public func getDataType() -> CloudBoostDataType? {
        if let val = document["dataType"] as? String {
            return CloudBoostDataType(rawValue: val)
        }
        return nil
    }
    
    public func getRequired() -> Bool?{
        return document["required"] as? Bool
    }
    
    public func getUnique() -> Bool?{
        return document["unique"] as? Bool
    }
    
    public func setRelatedTo(table: CloudTable){
        self.document["relatedTo"] = table.document
    }
    
    public func setRelatedTo(tableName: String){
        self.document["relatedTo"] = tableName
    }
    
    public func setRelatedToType(dataType: CloudBoostDataType){
        self.document["relatedTo"] = dataType.rawValue
    }
    
    public func setRelationType(type: String){
        self.document["relationType"] = type
    }
    
    public static func _defaultColumns(type: String) -> [NSMutableDictionary] {
        var col = [NSMutableDictionary]()
        
        let id = Column(name: "id", dataType: CloudBoostDataType.Id, required: true, unique: true)
        id.setIsRenamable(false)
        id.setIsDeletable(false)
        id.setIsEditable(false)
        
        let expires = Column(name: "expires", dataType: CloudBoostDataType.DateTime, required: false, unique: false)
        expires.setIsDeletable(false)
        expires.setIsEditable(false)
        
        let createdAt = Column(name: "createdAt", dataType: CloudBoostDataType.DateTime, required: true, unique: false)
        createdAt.setIsDeletable(false)
        createdAt.setIsEditable(false)
        
        let updatedAt = Column(name: "updatedAt", dataType: CloudBoostDataType.DateTime, required: true, unique: false)
        updatedAt.setIsDeletable(false)
        updatedAt.setIsEditable(false)
        
        let acl = Column(name: "ACL", dataType: CloudBoostDataType.ACL, required: true, unique: false)
        acl.setIsDeletable(false)
        acl.setIsEditable(false)
        
        col.append(id.document)
        col.append(expires.document)
        col.append(createdAt.document)
        col.append(updatedAt.document)
        col.append(acl.document)
        
        if(type == "custom") {
            return col
        }else if type == "user" {
            let username = Column(name: "username", dataType: CloudBoostDataType.Text, required: true, unique: true)
            username.setIsDeletable(false)
            username.setIsEditable(false)
            
            let email =  Column(name: "email", dataType: CloudBoostDataType.Email, required: false, unique: true)
            email.setIsDeletable(false)
            email.setIsEditable(false)
            
            let password =  Column(name: "password", dataType: CloudBoostDataType.EncryptedText, required: true, unique: false)
            password.setIsDeletable(false)
            password.setIsEditable(false)
            
            let roles = Column(name: "roles", dataType: CloudBoostDataType.List, required: false, unique: false)
            let role = CloudTable(tableName: "Role")
            roles.setRelatedTo(role)
            roles.setRelatedTo("role")
            roles.setRelationType("table")
            roles.setIsDeletable(false)
            roles.setIsEditable(false)
            col.append(username.document)
            col.append(roles.document)
            col.append(password.document)
            col.append(email.document)
            return col
        } else if type == "role" {
            let name = Column(name: "name", dataType: CloudBoostDataType.Text, required: true, unique: true)
            name.setIsDeletable(false)
            name.setIsEditable(false)
            col.append(name.document)
            return col
        }
        return col
    }
    
    
}