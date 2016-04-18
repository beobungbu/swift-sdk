//
//  CloudQueue.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudQueue{
    
    var acl: ACL
    var document = NSMutableDictionary()
    private var subscribers = [String]()
    private var queueType = "pull"
    var timeout = 1800
    var delay = 1800
    
    
    public init(queueName: String, queueType: String){
        self.acl = ACL()
        
        document["subscribers"] = self.subscribers
        
    }
    
    
}