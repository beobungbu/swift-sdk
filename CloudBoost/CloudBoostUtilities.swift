//
//  CloudBoostHelperFunctions.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation


public typealias callback = (status: Int, message: String) -> Void

public typealias CloudBoostDictionary = [ String : AnyObject ]

enum CloudBoostError: ErrorType {
    case ParsingError
    
}

func parseToJSON(dictionary: CloudBoostDictionary) throws -> NSData? {
    do {
        let jsonData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
        return jsonData
    } catch {
        throw CloudBoostError.ParsingError
    }
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
