//
//  CloudBoostHelperFunctions.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation


public typealias callback = (status: Int, message: String) -> Void

//Types of errors beig thrown by CloudBoost SDK
enum CloudBoostError: ErrorType {
    case ParsingError
    
}

public class CloudBoostResponse {
    public var success: Bool?
    public var status: Int?
    public var message: String?
    public var object: NSMutableDictionary?
}

// CLoudBoost Constans
enum CloudBoostConstants: String {
    case ID = "_id"
    case ACL = "ACL"
    case _tableName = "_tableName"
    case _type = "_type"
    case cretedAt = "createdAt"
    case updatedAt = "updatedAt"
    case _modifiedCloumns = "_modifiedColumns"
    case _isModified = "_isModified"
    case _isSearchable = "_isSearchable"
    case expires = "expires"
}


// This will be used to convert a NSDictionary/NSMutableDictionary to JSON data in form of NSData
extension NSDictionary{
    public func getJSON() throws -> NSData? {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(self, options: NSJSONWritingOptions(rawValue: 0))
            return jsonData
            
        } catch {
            throw CloudBoostError.ParsingError
        }
    }
}
