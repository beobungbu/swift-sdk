//
//  SearchObject.swift
//  CloudBoost
//
//  Created by Randhir Singh on 20/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class SearchQuery {
    var bool = NSMutableDictionary()
    var multi_match = NSMutableDictionary()
    var match = NSMutableDictionary()
    var _include = [String]()
    var must = [AnyObject]()
    var should = [AnyObject]()
    var must_not = [AnyObject]()
    
    
    
    public init(){
        bool["must"] = must
        bool["must_not"] = must_not
        bool["should"] = should
    }
    
    
    // MARK: Setter and getters
    
    public func getInclude() -> [String] {
        return _include
    }
    
    public func getMust() -> [AnyObject] {
        return must
    }
    
    public func getShould() -> [AnyObject] {
        return should
    }
    
    public func getMustNot() -> [AnyObject] {
        return must_not
    }
    
    public func setInclude(include: [String]){
        self._include = include
    }
    
    public func setMust(must: [AnyObject]) {
        self.must = must
    }
    
    public func setShould(should: [AnyObject]) {
        self.should = should
    }
    
    public func setMustNot(mustNot: [AnyObject]) {
        self.must_not = mustNot
    }
    
    public func getBool() -> NSMutableDictionary {
        return bool
    }
    
    public func getMultiMatch() -> NSMutableDictionary {
        return multi_match
    }
    
    public func getMatch() -> NSMutableDictionary {
        return match
    }
    
    public func setBool(bool: NSMutableDictionary) {
        self.bool = bool
    }
    
    public func setMultiMatch(multiMatch: NSMutableDictionary) {
        self.multi_match = multiMatch
    }
    
    public func setMatch(match: NSMutableDictionary) {
        self.match = match
    }
    
    // MARK: query functions
    
    public func _buildSearchOn(columnName: String, query: String?, fuzziness: String?, operatr: String?, match_percent: String?, boost: String?) -> NSMutableDictionary{
        let obj = NSMutableDictionary()
        let column = NSMutableDictionary()
        self.match = [:]
        
        column["query"] = query
        column["operator"] = operatr
        column["minimum_should_match"] = match_percent
        column["boost"] = boost
        column["fuzziness"] = fuzziness
        
        match[columnName] = column
        obj["match"] = match
        
        return obj
        
    }
    
    public func _buildSearchOn(columnName: [String], query: String?, fuzziness: String?, operatr: String?, match_percent: String?, boost: String?) -> NSMutableDictionary{
        let obj = NSMutableDictionary()
        self.multi_match = [:]
        
        multi_match["query"] = query
        multi_match["fields"] = columnName
        multi_match["operator"] = operatr
        multi_match["minimum_should_match"] = match_percent
        multi_match["boost"] = boost
        multi_match["fuzziness"] = fuzziness
        
        obj["multi_match"] = multi_match
        
        return obj
        
    }
    
    
    public func _buildSearchPhrase(columnName: String, query: String?, slop: String?, boost: String?) -> NSMutableDictionary{
        let obj = self._buildSearchOn(columnName, query: query, fuzziness: nil, operatr: nil, match_percent: nil, boost: boost)
        let column = NSMutableDictionary()
        match = [:]
        
        column["query"] = query
        column["type"] = "phrase"
        column["slop"] = slop
        
        match[columnName] = column
        
        obj["match"] = match
        
        return obj
    }
    
    public func _buildSearchPhrase(columnName: [String], query: String, slop: String?, boost: String?) -> NSMutableDictionary{
        let obj = self._buildSearchOn(columnName, query: query, fuzziness: nil, operatr: nil, match_percent: nil, boost: boost)
        multi_match = [:]
        
        multi_match["query"] = query
        multi_match["type"] = "phrase"
        multi_match["slop"] = slop
        
        obj["multi_match"] = multi_match
        
        return obj
    }

    public func _buildBestColumns(columnName: String, query: String?, fuzziness: String?, operatr: String?, match_percent: String?, boost: String?) -> NSMutableDictionary{
        let obj = self._buildSearchOn(columnName, query: query, fuzziness: fuzziness, operatr: operatr, match_percent: match_percent, boost: boost)
        let column = NSMutableDictionary()
        
        column["type"] = "best_fields"
        match[columnName] = column
        obj["match"] = match
        
        return obj
    }
    
    public func _buildBestColumns(columnName: [String], query: String?, fuzziness: String?, operatr: String?, match_percent: String?, boost: String?) -> NSMutableDictionary{
        let obj = self._buildSearchOn(columnName, query: query, fuzziness: fuzziness, operatr: operatr, match_percent: match_percent, boost: boost)
        
        multi_match["type"] = "best_fields"
        obj["multi_match"] = multi_match
        
        return obj
    }
    
    public func _buildMostColumns(columnName: String, query: String?, fuzziness: String?, operatr: String?, match_percent: String?, boost: String?) -> NSMutableDictionary{
        let obj = self._buildSearchOn(columnName, query: query, fuzziness: fuzziness, operatr: operatr, match_percent: match_percent, boost: boost)
        let column = NSMutableDictionary()
        
        column["type"] = "most_fields"
        match[columnName] = column
        obj["match"] = match
        
        return obj
    }
    
    public func _buildMostColumns(columnName: [String], query: String?, fuzziness: String?, operatr: String?, match_percent: String?, boost: String?) -> NSMutableDictionary{
        let obj = self._buildSearchOn(columnName, query: query, fuzziness: fuzziness, operatr: operatr, match_percent: match_percent, boost: boost)
        
        multi_match["type"] = "most_fields"
        obj["multi_match"] = multi_match
        
        return obj
    }
    
    public func searchOn(columns: String, query: String? = nil, fuzziness: String? = nil, all_words: String? = nil, match_percent: String? = nil, priority: String? = nil) -> SearchQuery {
        var aw = all_words
        if aw != nil {
            aw = "and"
        }
        
        let obj = self._buildSearchOn(columns, query: query, fuzziness: fuzziness, operatr: aw, match_percent: match_percent, boost: priority)
        
        self.should.append(obj)
        self.bool["should"] = should
        
        return self
    }
    
    
    public func phrase(columns: String, query: String?, fuzziness: String? = nil, priority: String? = nil) -> SearchQuery{
        let obj = self._buildSearchPhrase(columns, query: query, slop: fuzziness, boost: priority)
        self.should.append(obj)
        self.bool["should"] = should
        return self
    }
    
    public func bestColumns(columns: [String], query: String?, fuzziness: String?, all_words: String?, match_percent: String?, priority: String?) throws -> SearchQuery {
        
        if columns.count < 2 {
            throw CloudBoostError.InvalidArgument
        }
        
        var aw = all_words
        if aw != nil {
            aw = "and"
        }
        
        let obj = self._buildBestColumns(columns, query: query, fuzziness: fuzziness, operatr: aw, match_percent: match_percent, boost: priority)
        
        self.should.append(obj)
        self.bool["should"] = should
        
        return self
    }
    
    public func mostColumns(columns: [String], query: String?, fuzziness: String?, all_words: String?, match_percent: String?, priority: String?) throws -> SearchQuery {
        
        if columns.count < 2 {
            throw CloudBoostError.InvalidArgument
        }
        
        var aw = all_words
        if aw != nil {
            aw = "and"
        }
        
        let obj = self._buildMostColumns(columns, query: query, fuzziness: fuzziness, operatr: aw, match_percent: match_percent, boost: priority)
        
        self.should.append(obj)
        self.bool["should"] = should
        
        return self
    }
    
    
    public func startsWith(columnNmae: String, value: String?, priority: String?) -> SearchQuery{
        let obj = NSMutableDictionary()
        let prefix = NSMutableDictionary()
        let column = NSMutableDictionary()
        
        column["value"] = value
        
        if priority != nil {
            column["boost"] = priority
        }
        prefix[columnNmae] = column
        obj["prefix"] = prefix
        self.must.append(obj)
        self.bool["must"] = must
        
        return self
        
    }
    
    
    public func wildcard(columnNmae: String, value: String?, priority: String?) -> SearchQuery{
        let obj = NSMutableDictionary()
        let wildcard = NSMutableDictionary()
        let column = NSMutableDictionary()
        
        column["value"] = value
        
        if priority != nil {
            column["boost"] = priority
        }
        wildcard[columnNmae] = column
        obj["wildcard"] = wildcard
        self.should.append(obj)
        self.bool["should"] = should
        
        return self
        
    }
    
    
    public func regexp(columnNmae: String, value: String?, priority: String?) -> SearchQuery{
        let obj = NSMutableDictionary()
        let regexp = NSMutableDictionary()
        let column = NSMutableDictionary()
        
        column["value"] = value
        
        if priority != nil {
            column["boost"] = priority
        }
        regexp[columnNmae] = column
        obj["regexp"] = regexp
        self.must.append(obj)
        self.bool["must"] = must
        
        return self
        
    }
    
    
    public func and(object: SearchQuery) -> SearchQuery {
        self.must.append(object.bool)
        self.bool["must"] = must
        return self
    }
    
    public func or(object: SearchQuery) -> SearchQuery {
        let obj = NSMutableDictionary()
        obj["bool"] = object.bool
        
        self.should.append(obj)
        self.bool["should"] = should
        return self
    }
    
    public func not(object: SearchQuery) -> SearchQuery {
        self.must_not.append(object.bool)
        self.bool["must_not"] = must_not
        return self
    }
    
    
}