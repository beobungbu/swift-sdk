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
    public var objectClass: CloudObject.Type = CloudObject.self
    
    var searchFilter: SearchFilter?
    var searchQuery: SearchQuery?
    
    public init(tableName: String,
                searchQuery: SearchQuery? = nil,
                searchFilter: SearchFilter? = nil,
                objectClass: CloudObject.Type = CloudObject.self) {
        
        self.collectionName = tableName
        
        self.objectClass = objectClass
        
        if searchQuery != nil {
            self.bool["bool"] = searchQuery?.bool
            self.filtered["query"] = self.bool
        }else{
            self.filtered["query"] = [:]
        }
        if searchFilter != nil {
            self.bool["bool"] = searchFilter?.bool
            self.filtered["filter"] = self.bool
        }else{
            self.filtered["filter"] = [:]
        }
        
        self.from = 0
        self.size = 10
        
    }
    
    func setSearchFilter(searchFilter: SearchFilter) {
        self.bool["bool"] = searchFilter.bool
        self.filtered["query"] = self.bool
    }
    
    func setSearchQuery(searchQuery: SearchQuery){
        self.bool["bool"] = searchQuery.bool
        self.filtered["query"] = self.bool
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
        
        if let sf = self.searchFilter {
            self.setSearchFilter(sf)
        }
        if let sq = self.searchQuery {
            self.setSearchQuery(sq)
        }
        
        var collectionString = ""
        if self.collectionArray.count > 0 {
            if collectionArray.count > 1 {
                for i in 0...collectionArray.count-1 {
                    collectionString += (i>0 ? ","+self.collectionArray[i] : self.collectionArray[i])
                }
            }else{
                collectionString = collectionArray[0]
            }
            self.collectionName = collectionString
        }else{
            collectionString = self.collectionName!
        }
        query["filtered"] = filtered
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
                if let documents = response.object as? [NSMutableDictionary] {
                    
                    var objectsArray = [CloudObject]()
                    
                    for document in documents {
                        
                        var objectClass = self.objectClass
                        
                        let tableName = document["_tableName"] as! String
                        
                        switch tableName {
                            
                        case "Role":
                            objectClass = CloudRole.self
                            
                        case "User":
                            objectClass = CloudUser.self
                            
                        default:
                            objectClass = self.objectClass
                        }
                        
                        let object = objectClass.init(tableName: tableName)
                        object.document = document
                        
                        objectsArray.append(object)
                    }
                    
                    let theResponse = CloudBoostResponse()
                    theResponse.success = response.success
                    theResponse.object = objectsArray
                    theResponse.status = response.status
                    
                    callback(theResponse)
                } else if let document = response.object as? NSMutableDictionary {
                    
                    var objectClass = self.objectClass
                    
                    let tableName = document["_tableName"] as! String
                    
                    switch tableName {
                        
                    case "Role":
                        objectClass = CloudRole.self
                        
                    case "User":
                        objectClass = CloudUser.self
                        
                    default:
                        objectClass = self.objectClass
                    }
                    
                    let object = objectClass.init(tableName: tableName)
                    object.document = document
                    
                    let theResponse = CloudBoostResponse()
                    theResponse.success = response.success
                    theResponse.object = object
                    theResponse.status = response.status
                    
                    callback(theResponse)
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