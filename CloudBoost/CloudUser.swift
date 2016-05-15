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
        _modifiedColumns.append("email")
        document["_modifiedColumns"] = _modifiedColumns
    }
    
    public func setUsername(username: String){
        document["username"] = username
        _modifiedColumns.append("username")
        document["_modifiedColumns"] = _modifiedColumns
    }
    
    public func setPassword(password: String){
        document["password"] = password
        _modifiedColumns.append("password")
        document["_modifiedColumns"] = _modifiedColumns
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
    
    public func getVersion() -> String?{
        return document["_version"] as? String
    }
    
    // MARK: Cloud operations on CloudUser
    
    
    /**
     *
     * Sign Up
     *
     * @param callbackObject
     * @throws CloudBoostError
     */
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
            if(response.status == 200){
                self.document = response.object! as! NSMutableDictionary
            }
            callback(response: response)
        })
    }
    
    /**
     *
     * Log in
     *
     * @param callbackObject
     * @throws CloudBoostError
     */
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
            if response.success {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            // Save the user if he has been successfully logged in
            callback(response: response)
        })
    }
    
    /**
     *
     * Log out
     *
     * @param callbackObject
     * @throws CloudBoostError
     */
    func logout(callback: (response: CloudBoostResponse)->Void) throws{
        if(CloudApp.appID == nil){
            throw CloudBoostError.AppIdNotSet
        }
        if(document["username"] == nil){
            throw CloudBoostError.UsernameNotSet
        }
        if(document["password"] == nil){
            throw CloudBoostError.PasswordNotSet
        }
        
        // Setting the payload
        let data = NSMutableDictionary()
        data["document"] = document
        data["key"] = CloudApp.appKey
        let url = CloudApp.getApiUrl() + "/user/" + CloudApp.getAppId()! + "/logout"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            (response: CloudBoostResponse) in
            // save the response body into the current user
            if response.success {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            // return callback
            callback(response: response)
        })

    }
    
    /**
     *
     * Reset Password
     *
     * @param email
     * @param callbackObject
     * @throws CloudBoostError
     */
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
    
    /**
     *
     * Change Password
     *
     * @param email
     * @param callbackObject
     * @throws CloudBoostError
     */
    public func changePassword(oldPassword: String, newPassword: String, callback: (reponse: CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        data["key"] = CloudApp.getAppKey()
        data["oldPassword"] = oldPassword
        data["newPassword"] = newPassword
        let url = CloudApp.getApiUrl() + "/user/" + CloudApp.getAppId()! + "/changePassword"
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: data, callback: {
            (response: CloudBoostResponse) in
            if(CloudApp.isLogging()){
                response.log()
            }
            // Save the user if he has been successfully logged in
            if response.status == 200 && response.success {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(reponse: response)
        })
    }
    
    /**
     *
     * Add To Role
     *
     * @param role
     * @param callbackObject
     * @throws CloudBoostError
     */
    public func addToRole(role: CloudRole, callback: (response: CloudBoostResponse)-> Void) throws{
        if role.getName() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["user"] = self.document
        params["role"] = role.document
        params["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/user/" + CloudApp.getAppId()! + "/addToRole"
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response: response)
        })
    }
    
    /**
     *
     * Remove from Role
     *
     * @param role
     * @param callbackObject
     * @throws CloudBoostError
     */
    public func removeFromRole(role: CloudRole, callback: (response: CloudBoostResponse)->Void) throws{
        if role.getName() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["user"] = self.document
        params["role"] = role.document
        params["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/user/" + CloudApp.getAppId()! + "/removeFromRole"
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response: response)
        })

    }
    
    
}