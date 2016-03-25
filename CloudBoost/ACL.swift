//
//  ACL.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

/*

This is access control list

*/

import Foundation

public class ACL {
    
    var allowedReadUser = [String]()
    var allowedReadRole = [String]()
    var deniedReadUser = [String]()
    var deniedReadRole = [String]()
    var allowedWriteUser = [String]()
    var allowedWriteRole = [String]()
    var deniedWriteUser = [String]()
    var deniedWriteRole = [String]()
    var allowRead = NSMutableDictionary()
    var allowWrite = NSMutableDictionary()
    var denyRead = NSMutableDictionary()
    var denyWrite = NSMutableDictionary()
    var read = NSMutableDictionary()
    var write = NSMutableDictionary()
    var acl = NSMutableDictionary()
    
    public init(){
        allowedReadUser.append("all")
        allowedWriteUser.append("all")
        
        allowRead["user"] = allowedReadUser
        allowRead["role"] = allowedReadRole
        allowWrite["user"] = allowedWriteUser
        allowWrite["role"] = allowedWriteRole
        
        denyRead["user"] = deniedReadUser
        denyRead["role"] = deniedReadRole
        denyWrite["user"] = deniedWriteUser
        denyWrite["role"] = deniedWriteRole
        
        read["allow"] = allowRead
        read["deny"] = denyRead
        
        write["allow"] = allowWrite
        write["deny"] = denyWrite
        
        acl["read"] = read
        acl["write"] = write
    }

    
    public func getACL() -> NSMutableDictionary {
        return acl
    }
    
    public func getACLJSON() -> NSData? {
        do {
            if let jsonData = try acl.getJSON() {
                return jsonData
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}