//
//  CloudApp.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation
import SocketIOClientSwift

public class CloudApp: NSObject {
    
    public static var appID: String?
    public static var appKey: String?
    public var socket: SocketIOClient?
    
    var unsavedTables = [CloudEntity]()
    
    public static let serverUrl = "https://api.cloudboost.io"
    public static let serviceUrl = "https://service.cloudboost.io"
    public static let appUrl = serverUrl + "/api"
    public static let socketIoUrl = "https://realtime.cloudboost.io"
    
    
    public static var SESSION_ID: String?
    public static var MASTER_KEY: String?
    public static var socketUrl: String?
    
    
    
    public init(appID: String, appKey: String){
        print("Creating a new Cloud App...")
        CloudApp.appID = appID
        CloudApp.appKey = appKey
        socket = SocketIOClient(socketURL: NSURL(string: CloudApp.socketIoUrl)!, options: [.Log(true), .ForcePolling(true)])
    }
    
    public func printAppdetails(){
        print("App ID: " + CloudApp.appID! + "\nApp Key: " + CloudApp.appKey!)
    }
    
    
    
    public func saveTable(tableName: String, callback: (status: Int, message: String) -> Void){
        for table in unsavedTables {
            if(tableName == table.entityName){
                return
            }
        }
        callback(status: -1,message: "No table of that name found")
    }
    
    public func newEntity(entityName: String, attributes: NSMutableDictionary){
        unsavedTables.append(CloudEntity(entityName: entityName, attributes: attributes))
    }
    
        
    
}
