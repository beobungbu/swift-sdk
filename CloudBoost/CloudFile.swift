//
//  CloudFile.swift
//  CloudBoost
//
//  Created by Randhir Singh on 31/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudFile {
    var document = NSMutableDictionary()
    private var data: NSData?
    private var strEncodedData: String?
    
    
    public init(name: String, data: NSData, contentType: String){
        
        self.data = data
        self.strEncodedData = data.base64EncodedStringWithOptions([])
        
        document["_id"] = nil
        document["_type"] = "file"
        document["ACL"] = ACL().getACL()
        document["name"] = name
        document["size"] = data.length
        document["url"] = nil
        document["expires"] = nil
        document["contentType"] = contentType
    }
    
    public init(id: String){
        document["_id"] = id
    }
    
    public init(doc: NSMutableDictionary){
        self.document = doc
        self.data = nil
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
    
    public func getData() -> NSData? {
        return data
    }
    
    public func getExpires() -> NSDate? {
        if let expires = document["expires"] as? String {
            return CloudBoostDateFormatter.getISOFormatter().dateFromString(expires)
        }
        return nil
    }
    
    public func setExpires(date: NSDate) {
        document["expires"] = CloudBoostDateFormatter.getISOFormatter().stringFromDate(date)
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
    
    public func setDate(data: NSData) {
        self.data = data
        self.strEncodedData = data.base64EncodedStringWithOptions([])
    }
    
    
    // Save a CloudFile object
    public func save(callback: (response: CloudBoostResponse) -> Void){
        let params = NSMutableDictionary()
        params["key"] = CloudApp.getAppKey()!
        params["fileObj"] = self.document
        params["data"] = self.strEncodedData
        let url = CloudApp.getApiUrl() + "/file/" + CloudApp.getAppId()!
        
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            if(response.success) {
                self.document = (response.object as? NSMutableDictionary)!                
            }
            callback(response: response)
        })
    }
    
    
    // Save an array of CloudFile
    public static func saveAll(array: [CloudFile], callback: (CloudBoostResponse)->Void) {
        
        // Ready the response
        let resp = CloudBoostResponse()
        resp.success = true
        var count = 0
        
        // Iterate through the array
        for object in array {
            let url = CloudApp.serverUrl + "/file/" + CloudApp.appID!
            let params = NSMutableDictionary()
            params["key"] = CloudApp.appKey!
            params["fileObj"] = object.document
            params["data"] = object.strEncodedData
            
            CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback:
                {(response: CloudBoostResponse) in
                    count += 1
                    if(response.success){
                        if let newDocument = response.object {
                            object.document = newDocument as! NSMutableDictionary
                        }
                    }else{
                        resp.success = false
                        resp.message = "one or more objects were not saved"
                    }
                    if(count == array.count){
                        resp.object = count
                        callback(resp)
                    }
            })
        }
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
            if response.success && (response.status >= 200 || response.status < 300) {
                self.document = [:]
            }
            callback(response: response)
        })
        
    }
    
    public static func getFileFromUrl(url: NSURL, callback: (response: CloudBoostResponse)->Void){
        let cbResponse = CloudBoostResponse()
        cbResponse.success = false
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error -> Void in
            guard let httpRes = response as? NSHTTPURLResponse else {
                cbResponse.message = "Proper response not received"
                callback(response: cbResponse)
                return
            }
            cbResponse.status = httpRes.statusCode
            if( httpRes.statusCode == 200){
                guard let strEncodedData = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String else {
                    cbResponse.message = "Error in encoding/decoding"
                    callback(response: cbResponse)
                    return
                }
                let nsData = NSData(base64EncodedString: strEncodedData, options: [])
                cbResponse.success = true
                cbResponse.object = nsData                
            } else {
                cbResponse.message = "\(httpRes.statusCode) error"
            }
            callback(response: cbResponse)
            
        }).resume()

    }
    
    public func uploadSave(progressCallback : (response: CloudBoostProgressResponse)->Void){
        let params = NSMutableDictionary()
        params["key"] = CloudApp.getAppKey()!
        params["fileObj"] = self.document
        params["data"] = self.strEncodedData
        let url = CloudApp.getApiUrl() + "/file/" + CloudApp.getAppId()!
        
        CloudCommunications()._requestFile("POST", url: NSURL(string: url)!, params: params, data: data, uploadCallback: {
            uploadResponse in
            progressCallback(response: uploadResponse)
        })
    }
    
    public func fetch(callback: (CloudBoostResponse)->Void){
        let res = CloudBoostResponse()
        let query = CloudQuery(tableName: "_File")
        if getId() == nil {
            res.message = "ID not set in the object"
            callback(res)
        }else{
            try! query.equalTo("id", obj: getId()!)
            query.setLimit(1)
            try! query.find({ res in
                if res.success {
                    if let obj = res.object as? [NSMutableDictionary] {
                        self.document = obj[0]
                        callback(res)
                    }else{
                        res.success = false
                        res.message = "Invalid response received"
                        callback(res)
                    }
                }else{
                    res.message = "Failed to fetch"
                    callback(res)
                }
            })
        }
    }
    
    
    
}