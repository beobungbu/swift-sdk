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
    case AppIdNotSet
    case UsernameNotSet
    case PasswordNotSet
    case EmailNotSet
    case InvalidGeoPoint
    case InvalidArgument
    case InvalidDataType
}

public class CloudBoostResponse {
    public var success = false
    public var status: Int?
    public var message: String?
    public var object: AnyObject?
    
    public func log() {
        print("Success? \(success)")
        print("Status: \(status)")
        print("Message: \(message)")
        print("Object: \(object)")
    }
}

// CLoudBoost Constans
public enum CloudBoostDataType: String {
    case Text = "Text"
    case Email = "Email"
    case URL = "URL"
    case Number = "Number"
    case Boolean = "Boolean"
    case DateTime = "DateTime"
    case GeoPoint = "GeoPoint"
    case File = "File"
    case List = "List"
    case Relation = "Relation"
    case Object = "Object"
    case Id = "Id"
    case EncryptedText = "EncryptedText"
    case ACl = "ACL"
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

public class CloudBoostDateFormatter{
    public static func getISOFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        return formatter
    }
}

// Utility class

public class Util {
    
    public static func makeString(len: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        return randomString as String
    }
    
    public static func makeEmail() -> String{
        return self.makeString(12) + "@sample.com"
    }
    
}


public class CloudBoostCache {
    
    public static func _createCookie(){
        
    }
    
    public static func _deleteCookie(){
        
    }
    
    public static func _getCookie(){
        
    }
}





