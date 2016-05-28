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
        setupACL()
    }
    
    private func setupACL(){
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
    
    public init(acl: NSMutableDictionary){
        self.acl = acl
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
    
    /**
     * get an Array of String of role Id's which are allowed to access resource,role Id's are instances of {@link io.cloudboost.CloudRole}
     * @return [String]
     */
    public func getAllowedReadRole() -> [String]? {
        guard let read = acl["read"] as? NSMutableDictionary else {
            return nil
        }
        guard let allowedRead = read["allow"] as? NSMutableDictionary else {
            return nil
        }
        guard let role = allowedRead["role"] as? [String] else {
            return nil
        }
        allowedReadRole = []
        for (_, el) in role.enumerate() {
            allowedReadRole.append(el)
        }
        return allowedReadRole
    }
    
    /**
     * get an Array of String of role Id's which are allowed to modify resource,role Id's are instances of {@link io.cloudboost.CloudRole}
     * @return [String]
     */
    public func getAllowedWriteRole() -> [String]? {
        guard let read = acl["write"] as? NSMutableDictionary else {
            return nil
        }
        guard let allowedRead = read["allow"] as? NSMutableDictionary else {
            return nil
        }
        guard let role = allowedRead["role"] as? [String] else {
            return nil
        }
        allowedWriteRole = []
        for (_, el) in role.enumerate() {
            allowedWriteRole.append(el)
        }
        return allowedWriteRole
    }
    
    /**
     * get an Arroy of String of User Id's which are allowed to access this resource
     * @return [String]
     */
    public func getAllowedReadUser() -> [String]? {
        guard let read = acl["read"] as? NSMutableDictionary else {
            return nil
        }
        guard let allowedRead = read["allow"] as? NSMutableDictionary else {
            return nil
        }
        guard let role = allowedRead["user"] as? [String] else {
            return nil
        }
        allowedReadRole = []
        for (_, el) in role.enumerate() {
            allowedReadRole.append(el)
        }
        return allowedReadRole
    }
    
    /**
     * get an Arroy of String of User Id's which are allowed to modify this resource
     * @return [String]
     */
    public func getAllowedWriteUser() -> [String]? {
        guard let read = acl["write"] as? NSMutableDictionary else {
            return nil
        }
        guard let allowedRead = read["allow"] as? NSMutableDictionary else {
            return nil
        }
        guard let role = allowedRead["user"] as? [String] else {
            return nil
        }
        allowedWriteUser = []
        for (_, el) in role.enumerate() {
            allowedWriteUser.append(el)
        }
        return allowedWriteUser
    }
    
    /**
     * get an Arroy of String of User Id's which are denied to access this resource
     * @return [String]
     */
    public func getDeniedReadUser() -> [String]? {
        guard let read = acl["read"] as? NSMutableDictionary else {
            return nil
        }
        guard let allowedRead = read["deny"] as? NSMutableDictionary else {
            return nil
        }
        guard let role = allowedRead["user"] as? [String] else {
            return nil
        }
        allowedReadRole = []
        for (_, el) in role.enumerate() {
            allowedReadRole.append(el)
        }
        return allowedReadRole
    }
    
    /**
     * get an Arroy of String of User Id's which are denied to modify this resource
     * @return [String]
     */
    public func getDeniedWriteUser() -> [String]? {
        guard let read = acl["write"] as? NSMutableDictionary else {
            return nil
        }
        guard let allowedRead = read["deny"] as? NSMutableDictionary else {
            return nil
        }
        guard let role = allowedRead["user"] as? [String] else {
            return nil
        }
        allowedWriteUser = []
        for (_, el) in role.enumerate() {
            allowedWriteUser.append(el)
        }
        return allowedWriteUser
    }
    
    public func setPublicReadAccess(value: Bool) {
        if value {
            self.allowedReadUser = ["all"]
        } else {
            self.allowedReadUser = []
        }
        setupACL()
    }
    
    public func setPublicWriteAccess(value: Bool){
        if value {
            self.allowedWriteUser = ["all"]
        } else {
            self.allowedWriteUser = []
        }
        setupACL()
    }
    
    public func setUserWriteAccess(uid: String, value: Bool){
        var index: Int?
        allowedWriteUser = getAllowedWriteUser()!
        deniedWriteUser = getDeniedWriteUser()!
        
        if value {
            index = allowedWriteUser.indexOf("all")
            if index != nil {
                allowedWriteUser.removeAtIndex(index!)
            }
            index = allowedWriteUser.indexOf(uid)
            if index == nil {
                allowedWriteUser.append(uid)
            }
        }else{
            index = allowedWriteUser.indexOf(uid)
            if index > -1 {
                allowedWriteUser.removeAtIndex(index!)
            }
            deniedWriteUser.append(uid)
        }
        
        allowWrite["user"] = allowedWriteUser
        denyWrite["user"] = deniedWriteUser
        write["deny"] = denyWrite
        write["allow"] = allowWrite
        
    }
    
    public func setUserReadAccess(uid: String, value: Bool){
        var index: Int?
        allowedReadUser = getAllowedReadUser()!
        deniedReadUser = getDeniedReadUser()!
        
        if value {
            index = allowedReadUser.indexOf("all")
            if index != nil {
                allowedReadUser.removeAtIndex(index!)
            }
            index = allowedReadUser.indexOf(uid)
            if index == nil {
                allowedReadUser.append(uid)
            }
        }else{
            index = allowedReadUser.indexOf(uid)
            if index > -1 {
                allowedReadUser.removeAtIndex(index!)
            }
            deniedReadUser.append(uid)
        }
        
        allowRead["user"] = allowedReadUser
        denyRead["user"] = deniedReadUser
        read["deny"] = denyRead
        read["allow"] = allowRead
        
    }
    
    public func setRoleWriteAccess(roleID: String, value: Bool){
        var index: Int?
        allowedWriteUser = getAllowedWriteUser()!
        deniedWriteUser = getDeniedWriteUser()!
        
        if value {
            index = allowedWriteUser.indexOf("all")
            if index != nil {
                allowedWriteUser.removeAtIndex(index!)
            }
            index = allowedWriteRole.indexOf(roleID)
            if index == nil {
                allowedWriteRole.append(roleID)
            }
        }else{
            index = allowedWriteRole.indexOf(roleID)
            if index > -1 {
                allowedWriteRole.removeAtIndex(index!)
            }
            deniedWriteRole.append(roleID)
        }
        
        allowWrite["role"] = allowedWriteRole
        denyWrite["role"] = deniedWriteRole
        write["deny"] = denyWrite
        write["allow"] = allowWrite
        
    }
    
    public func setRoleReadAccess(roleID: String, value: Bool){
        var index: Int?
        allowedReadUser = getAllowedReadUser()!
        deniedReadUser = getDeniedReadUser()!
        
        
        if value {
            index = allowedReadUser.indexOf("all")
            if index != nil {
                allowedReadUser.removeAtIndex(index!)
            }
            index = allowedReadRole.indexOf(roleID)
            if index == nil {
                allowedReadRole.append(roleID)
            }
        }else{
            index = allowedReadRole.indexOf(roleID)
            if index > -1 {
                allowedReadRole.removeAtIndex(index!)
            }
            deniedReadRole.append(roleID)
        }
        
        allowRead["role"] = allowedReadRole
        denyRead["role"] = deniedReadRole
        read["deny"] = denyRead
        read["allow"] = allowRead
        
    }

    
    
    
    
}