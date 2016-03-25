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
    
    // MARK:- Setters
    
    public func setColumnName(value: String){
        document["name"] = value
    }
    
    public func setRequired(value: Bool){
        document["required"] = value
    }
    
    public func setUnique(value: Bool){
        document["unique"] = value
    }
    
    // MARK:- Getter
    
    public func getColumnName() -> String? {
        return document["name"] as? String
    }
    
    public func getRequired() -> Bool?{
        return document["required"] as? Bool
    }
    
    public func getUnique() -> Bool?{
        return document["unique"] as? Bool
    }
}