//
//  CloudCache.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudCache {
    private var document = NSMutableDictionary()
    private var size: Int?
    private var cacheName: String?
    private var items = [NSMutableDictionary]()
    private var _tableName: String?
    
    public init(cacheName: String) throws{
        if "" == cacheName {
            throw CloudBoostError.InvalidArgument
        }
        self._tableName = "cache"
        self.size = 0
        self.cacheName = cacheName
        
        document["_tableName"] = _tableName
        document["size"] = size
        document["items"] = items
        document["name"] = cacheName
        
    }
    
    // MARK: Getters and Setters
    
    public func getCacheName() -> String? {
        return cacheName
    }
    
    public func getCacheSize() -> String? {
        return document["size"] as? String
    }
    
    public func getDocument() -> NSMutableDictionary? {
        return document
    }
    
    public func setCacheName(cacheName: String) {
        self.cacheName = cacheName
    }
    
    public func setDocument(document: NSMutableDictionary) {
        self.document = document
    }
    
    
    // MARK: Cloud call
    
    public func set(key: String, value: AnyObject?, callback: (CloudBoostResponse)-> Void) throws{
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if key == "" {
            throw CloudBoostError.InvalidArgument
        }
        if value == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        params["item"] = value
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/" + key
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func addItem(key: String, value: AnyObject, callback: (CloudBoostResponse)-> Void) throws{
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if key == "" {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        params["item"] = value
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/\(key)"
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func deleteItem(key: String, callback: (CloudBoostResponse)-> Void) throws{
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if key == "" {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/item/\(key)"
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func getItem(key: String, callback: (CloudBoostResponse)-> Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if key == "" {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/\(key)/item"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func create(callback: (CloudBoostResponse)-> Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/create"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func getItemsCount(callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/items/count"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public static func getAllCache(callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()!
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func getAllItems(callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)" + "/items"
        print(url)
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func clear(callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/clear"
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func delete(callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)"
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })

    }
    
    public static func deleteAll(callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()!
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
        
    }
    
    public func get(key: String, callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if key == "" {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)/\(key)/item"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    public func getInfo(callback: (CloudBoostResponse)->Void) throws {
        if CloudApp.getAppId() == nil {
            throw CloudBoostError.InvalidArgument
        }
        if CloudApp.getAppKey() == nil {
            throw CloudBoostError.InvalidArgument
        }
        let params = NSMutableDictionary()
        params["key"] = CloudApp.masterKey
        let url = CloudApp.getApiUrl() + "/cache/" + CloudApp.getAppId()! + "/\(self.cacheName!)"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            response in
            callback(response)
        })
    }
    
    
}