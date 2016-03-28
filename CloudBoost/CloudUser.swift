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
    
    public func signup(email: String, callback: (response: CloudBoostResponse)->Void) throws{
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
        let url = CloudApp.appUrl + "/user/" + CloudApp.appID! + "/signup"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            (response: CloudBoostResponse) in
            if(CloudApp.isLogging()){
                response.log()
            }
        })
    }
    
    
    
}