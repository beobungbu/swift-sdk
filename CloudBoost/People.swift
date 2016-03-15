//
//  CloudBoost.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class People {
    var appID: String?
    var appKey: String?
    
    public init(appID: String, appKey: String){
        self.appID = appID
        self.appKey = appKey
    }
    
    public func printAppdetails(){
        print("App ID: " + appID! + "\nApp Key: " + appKey!)
    }
}
