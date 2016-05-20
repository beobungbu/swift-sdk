//
//  SearchFilter.swift
//  CloudBoost
//
//  Created by Randhir Singh on 20/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class SearchFilter {
    
    var bool = NSMutableDictionary()
    var _include = [String]()
    var must = [AnyObject]()
    var should = [AnyObject]()
    var must_not = [AnyObject]()
    
    
    public init(){
        bool["must"] = must
        bool["should"] = should
        bool["must_not"] = must_not
    }
    
    public func notEqualTo(columnName: String, data: AnyObject){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["term"] = [ colName : data ]
        must_not.append(term)
        bool["must_not"] = must_not
    }
    
    public func notEqualTo(columnName: String, data: [AnyObject]){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["terms"] = [ colName : data ]
        must_not.append(term)
        bool["must_not"] = must_not
    }

    public func equalTo(columnName: String, data: AnyObject){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["term"] = [ colName : data ]
        must.append(term)
        bool["must"] = must
    }
    
    public func equalTo(columnName: String, data: [AnyObject]){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["terms"] = [ colName : data ]
        must.append(term)
        bool["must"] = must
    }

    public func exists(columnName: String){
        let colName = prependUnderscore(columnName)
        
        must.append([ "exists" : ["field":colName] ])
        bool["must"] = must
    }
    
    public func doesNotExists(columnName: String){
        let colName = prependUnderscore(columnName)
        
        must.append([ "missing" : ["field":colName] ])
        bool["must"] = must
    }
    
    public func greaterThanEqualTo(columnName: String, data: AnyObject){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["range"] = [colName : [ "gte" : data ] ]
        must.append(term)
        bool["must"] = must
    }
    
    public func greaterThan(columnName: String, data: AnyObject){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["range"] = [colName : [ "gt" : data ] ]
        must.append(term)
        bool["must"] = must
    }
    
    public func lessThanEqualTo(columnName: String, data: AnyObject){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["range"] = [colName : [ "lte" : data ] ]
        must.append(term)
        bool["must"] = must
    }
    
    public func lessThan(columnName: String, data: AnyObject){
        let colName = prependUnderscore(columnName)
        
        let term = NSMutableDictionary()
        term["range"] = [colName : [ "lt" : data ] ]
        must.append(term)
        bool["must"] = must
    }
    
    public func and(searchFilter: SearchFilter) throws -> SearchFilter {
        if searchFilter._include.count > 0 {
            throw CloudBoostError.InvalidArgument
        }
        self._include = []
        self.must.append(searchFilter.bool)
        self.bool["must"] = self.must
        return self
    }
    
    public func or(searchFilter: SearchFilter) -> SearchFilter? {
        if searchFilter._include.count > 0 {
            return nil
        }
        self._include = []
        self.should.append(searchFilter.bool)
        self.bool["should"] = self.should
        return self
    }
    
    public func not(searchFilter: SearchFilter) throws -> SearchFilter {
        if searchFilter._include.count > 0 {
            throw CloudBoostError.InvalidArgument
        }
        self._include = []
        self.must_not.append(searchFilter.bool)
        self.bool["must_not"] = self.must_not
        return self
    }

    public func include(columnName: String) -> SearchFilter {
        let colName = prependUnderscore(columnName)
        self._include.append(colName)
        return self
    }
    
    public func near(columnName: String, geoPoint: CloudGeoPoint, distance: Int){
        let obj = NSMutableDictionary()
        obj["geo_distance"] = ["distance":distance.description + " m"]
        obj[columnName] = geoPoint.getCoordinates()
        self.must.append(obj)
        self.bool["must"] = must
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