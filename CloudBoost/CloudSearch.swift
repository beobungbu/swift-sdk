//
//  CloudSearch.swift
//  CloudBoost
//
//  Created by Randhir Singh on 20/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudSearch {
    var collectionName: String?
    var collectionArray = [String]()
    var query = NSMutableDictionary()
    var filtered = NSMutableDictionary()
    var bool = NSMutableDictionary()
    var from: Int?
    var size: Int?
    var sort = [AnyObject]()
    
    
    public init(tableName: String, searchObject: SearchQuery?, searchFilter: SearchFilter?){
        self.collectionName = tableName
        
        if searchObject != nil {
            self.bool["bool"] = searchObject?.bool
            self.filtered["query"] = self.bool
        }else{
            self.filtered["query"] = [:]
        }
        
        if searchFilter != nil {
            self.bool["bool"] = searchFilter?.bool
            self.filtered["query"] = self.bool
        }else{
            self.filtered["query"] = [:]
        }
        
        self.from = 0
        self.size = 10
        
    }
    
    public init(tableName: [String], searchObject: SearchQuery?, searchFilter: SearchFilter?){
        self.collectionArray = tableName
        
        if searchObject != nil {
            self.bool["bool"] = searchObject?.bool
            self.filtered["query"] = self.bool
        }else{
            self.filtered["query"] = [:]
        }
        
        if searchFilter != nil {
            self.bool["bool"] = searchFilter?.bool
            self.filtered["query"] = self.bool
        }else{
            self.filtered["query"] = [:]
        }
        
        self.from = 0
        self.size = 10
        
    }

    
    // MARK: Setters and getter
    
    public func setSkip(data: Int ){
        self.from = data
    }
    
    public func setLimit(data: Int) {
        self.size = data
    }
    
    public func orderByAsc(columnName: String) -> CloudSearch {
        let colName = prependUnderscore(columnName)
        
        let obj = NSMutableDictionary()
        obj[colName] = ["order":"asc"]
        self.sort.append(obj)
        
        return self
        
    }
    
    public func orderByDesc(columnName: String) -> CloudSearch {
        let colName = prependUnderscore(columnName)
        
        let obj = NSMutableDictionary()
        obj[colName] = ["order":"desc"]
        self.sort.append(obj)
        
        return self
        
    }
    
    public func search(callback: (CloudBoostResponse)->Void) throws {
        var collectionString = ""
        if self.collectionArray.count > 0 {
            if collectionArray.count > 1 {
                for i in 1...collectionArray.count {
                    collectionString += (i>0 ? ","+self.collectionArray[i] : self.collectionArray[i])
                }
            }else{
                collectionString = collectionArray[0]
            }
        }else{
            collectionString = self.collectionName!
        }
        
        let params = NSMutableDictionary()
        params["collectionName"] = collectionString
        params["query"] = query
        params["limit"] = size
        params["skip"] = from
        params["sort"] = sort
        params["key"] = CloudApp.getAppKey()
        
        var url = CloudApp.getApiUrl() + "/data/" + CloudApp.getAppId()!
        url = url + "/" + collectionName! + "/search"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: params, callback: {
            (response: CloudBoostResponse) in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var msgArr = [CloudObject]()
                    for el in doc {
                        let msg = CloudObject(tableName: el["_tableName"]as!String)
                        msg.document = el
                        msgArr.append(msg)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msgArr
                    resp.status = response.status
                    callback(resp)
                } else if let doc = response.object as? NSMutableDictionary {
                    let msg = CloudObject(tableName: doc["_tableName"]as!String)
                    msg.document = doc
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }
        })
        
    }
    
    
    private func prependUnderscore(col: String) -> String {
        var returnString = col
        let keyWords = ["id","isSearchable","expires"]
        if keyWords.indexOf(col) != nil {
            returnString = "_" + returnString
        }
        return returnString
    }
}