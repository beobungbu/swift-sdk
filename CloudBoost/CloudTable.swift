//
//  CloudTable.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudTable {
    
    public var tableName: String?
    public var attributes: NSDictionary?
    
    public init(tableName: String, attributes: NSDictionary){
        self.tableName = tableName
        self.attributes = attributes
    }
    
}