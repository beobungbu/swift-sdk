//
//  CloudSearch.swift
//  CloudBoost
//
//  Created by Randhir Singh on 20/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

@available(*,deprecated=0.2) public class CloudSearch {
    var collectionName: String?
    var collectionArray = [String]()
    var query = NSMutableDictionary()
    var filtered = NSMutableDictionary()
    var bool = NSMutableDictionary()
    var from: Int?
    var size: Int?
    var sort = [AnyObject]()
    
    var searchFilter: SearchFilter?
    var searchQuery: SearchQuery?
    
    ///
    /// CloudObject subclass to be used to construct objects fetched with the `.search` method
    /// Usage:
    /// 1. Declare your own CloudObject subclass
    /// 2. Initialize a CloudSearch passing your subclass type as a parameter or set the objectClass property
    /// 3. Call the .search method
    ///
    public var objectClass: CloudObject.Type = CloudObject.self
    
    /// Instantiate a new QuerySearch object
    ///
    /// - parameters:
    ///   - tableName: Name of the table on the backend
    ///   - searchQuery: An SearchQuery object for the criteria of the search (optional)
    ///   - searchFiler: An SearchFilter object with the filtering options of the search (optional)
    ///   - objectClass: The type of object to be returned (must be a subclass of CloudObject); is optional and if omitted will be created CloudObject instances
    ///
    public init(tableName: String,
                searchQuery: SearchQuery? = nil,
                searchFilter: SearchFilter? = nil,
                objectClass: CloudObject.Type = CloudObject.self) {
        
        self.objectClass = objectClass
        self.collectionName = tableName

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
    
    public init(tableName: [String],
                searchQuery: SearchQuery? = nil,
                searchFilter: SearchFilter? = nil,
                objectClass: CloudObject.Type = CloudObject.self) {
        
        self.objectClass = objectClass
        self.collectionArray = tableName
        
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

    
//    public init(tableName: String){
//        self.collectionName = tableName
//
//        self.filtered["query"] = [:]
//        self.filtered["filter"] = [:]
//        
//        self.from = 0
//        self.size = 10
//        
//    }
    
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

                        let object = self.objectClass.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)

                        objectsArray.append(object)
                    }
                    
                    let theResponse = CloudBoostResponse()
                    theResponse.success = response.success
                    theResponse.object = objectsArray
                    theResponse.status = response.status
                    
                    callback(theResponse)
                } else if let document = response.object as? NSMutableDictionary {
                    
                    let object = self.objectClass.cloudObjectFromDocumentDictionary(document, documentType: self.objectClass)
                    
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