//
//  CloudUser.swift
//  CloudBoost
//
//  Created by Randhir Singh on 27/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudUser: CloudObject {
    
    
    public init(username: String, password: String){
        super.init(tableName: "User")
        
        document["username"] = username
        document["password"] = password
        
        _modifiedColumns.append("username")
        _modifiedColumns.append("password")
        
        document["_modifiedColumns"] = _modifiedColumns
    }
    
    // MARK: Setters
    
    public func setEmail(email: String) {
        document["email"] = email
    }
    
    public func setUsername(username: String){
        document["username"] = username
    }
    
    public func setPassword(password: String){
        document["password"] = password
    }
    
    // MARK: Getters
    
    public func getUsername() -> String? {
        return document["username"] as? String
    }
    
    public func getEmail() -> String? {
        return document["email"] as? String
    }
    
    public func getPassword() -> String? {
        return document["password"] as? String
    }
    
    // MARK: Cloud operations on CloudUser
    
    
    // Signup a user on the app
    public func signup(callback: (response: CloudBoostResponse)->Void) throws{
        if(CloudApp.appID == nil){
            throw CloudBoostError.AppIdNotSet
        }
        if(document["username"] == nil){
            throw CloudBoostError.UsernameNotSet
        }
        if(document["email"] == nil){
            throw CloudBoostError.EmailNotSet
        }
        if(document["password"] == nil){
            throw CloudBoostError.PasswordNotSet
        }
        
        // Setting the payload
        let data = NSMutableDictionary()
        data["document"] = document
        data["key"] = CloudApp.appKey
        let url = CloudApp.getApiUrl() + "/user/" + CloudApp.getAppId()! + "/signup"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            (response: CloudBoostResponse) in
            if(CloudApp.isLogging()){
                response.log()
            }
            // Save the user if he has been successfully logged in
            callback(response: response)
        })
    }
    
    // Login a user
    public func login(callback: (response: CloudBoostResponse)->Void) throws {
        if(CloudApp.appID == nil){
            throw CloudBoostError.AppIdNotSet
        }
        if(document["username"] == nil){
            throw CloudBoostError.UsernameNotSet
        }
        if(document["email"] == nil){
            throw CloudBoostError.EmailNotSet
        }
        if(document["password"] == nil){
            throw CloudBoostError.PasswordNotSet
        }

        // Setting the payload
        let data = NSMutableDictionary()
        data["document"] = document
        data["key"] = CloudApp.appKey
        let url = CloudApp.getApiUrl() + "/user/" + CloudApp.getAppId()! + "/login"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            (response: CloudBoostResponse) in
            if(CloudApp.isLogging()){
                response.log()
            }
            // Save the user if he has been successfully logged in
            callback(response: response)
        })
    }
    
    // Reset password
    public static func resetPassword(email: String, callback: (reponse: CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        data["key"] = CloudApp.getAppKey()
        data["email"] = email
        let url = CloudApp.getApiUrl() + "/user/" + CloudApp.getAppId()! + "/resetPassword"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            (response: CloudBoostResponse) in
            if(CloudApp.isLogging()){
                response.log()
            }
            // Save the user if he has been successfully logged in
            callback(reponse: response)
        })
    }
    
    
}