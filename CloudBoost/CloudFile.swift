//
//  CloudFile.swift
//  CloudBoost
//
//  Created by Randhir Singh on 31/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CLoudFile {
    var document = NSMutableDictionary()
    private var data: String?
    
    
    public init(name: String, data: NSData, contentType: String){
        
        self.data = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        document["_id"] = nil
        document["_type"] = "file"
        document["ACL"] = ACL().getACL()
        document["name"] = name
        document["size"] = data.length
        document["url"] = nil
        document["expires"] = nil
        document["contentType"] = contentType
    }
    
    // MARK: Getters
    
    public func getId() -> String?  {
        return document["_id"] as? String
    }
    
    public func getContentType() -> String? {
        return document["contentType"] as? String
    }
    
    public func getFileUrl() -> String? {
        return document["url"] as? String
    }
    
    public func getFileName() -> String? {
        return document["name"] as? String
    }
    
    public func getACL() -> ACL? {
        if let acl = document["ACL"] as? NSMutableDictionary {
            return ACL(acl: acl)
        }
        return nil
    }
    
    // MARK: Setters
    
    public func setId(id: String){
        document["_id"] = id
    }
    
    public func setContentType(contentType: String){
        document["contentType"] = contentType
    }
    
    public func setFileUrl(url: String){
        document["url"] = url
    }
    
    public func setFileName(name: String){
        document["name"] = name
    }
    
    public func setACL(acl: ACL){
        document["ACL"] = acl.getACL()
    }
    
    
    // Save a CloudFile object
    public func save(callback: (response: CloudBoostResponse) -> Void){
        let params = NSMutableDictionary()
        params["key"] = CloudApp.getAppKey()!
        params["fileObj"] = self.document
        params["data"] = self.data
        let url = CloudApp.getApiUrl() + "/file/" + CloudApp.getAppId()!
        
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            self.document = (response.object as? NSMutableDictionary)!
            callback(response: response)
        })
    }
    
    // delete a CloudFile
    public func delete(callback: (response: CloudBoostResponse) -> Void) throws {
        guard let _ = document["url"] else{
            throw CloudBoostError.InvalidArgument
        }
        
        let params = NSMutableDictionary()
        params["fileObj"] = document
        params["key"] = CloudApp.getAppKey()!
        
        let url = CloudApp.getApiUrl() + "/file/" + CloudApp.getAppId()! + "/" + self.getId()!
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            callback(response: response)
        })
        
    }
    
    
    
    
    
}