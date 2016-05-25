//
//  CloudApp.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation
//import SocketIOClientSwift

public class CloudApp: NSObject {
    
    public static var appID: String?
    public static var appKey: String?
    public static var masterKey: String?
    //public var socket: SocketIOClient?
    
    public static var objectsMapping = [String: CloudObject.Type]()
    
    //detarmines if the API Logs, defaults to false
    private static var log = false
    
    public static let serverUrl = "https://api.cloudboost.io"
    public static let serviceUrl = "https://service.cloudboost.io"
    public static let appUrl = serverUrl + "/api"
    public static let apiUrl = serverUrl
    public static let socketIoUrl = "https://api.cloudboost.io"
    
    public static var SESSION_ID: String?
    public static var MASTER_KEY: String?
    public static var socketUrl: String?
    
    public init(appID: String, appKey: String){
        print("Creating a new Cloud App...")
        CloudApp.appID = appID
        CloudApp.appKey = appKey
        CloudSocket.socket = SocketIOClient(socketURL: NSURL(string: CloudApp.socketIoUrl)!, options: [.Log(true), .ForcePolling(false)])
    }
    
    public func printAppdetails(){
        print("App ID: " + CloudApp.appID! + "\nApp Key: " + CloudApp.appKey!)
    }
    
    public class func objectClassForTableName(tableName: String) -> CloudObject.Type {
        
        if let objectClass = self.objectsMapping[tableName] {
            return objectClass
        }
        
        switch  tableName {
        case "User":
            return CloudUser.self
        case "Role":
            return CloudRole.self
        default:
            return CloudObject.self
        }
    }
    
    // MARK:- Setter functions
    
    public func setIsLogging(value: Bool){
        CloudApp.log = value
    }
    
    public func setMasterKey(value: String){
        CloudApp.masterKey = value
    }
    
    // MARK:- Getter functions
    
    public static func isLogging() -> Bool {
        return CloudApp.log
    }
    
    public static func getAppId() -> String? {
        return appID
    }
    
    public static func getAppKey() -> String? {
        return appKey
    }
    
    public static func getAppUrl() -> String {
        return appUrl
    }
    
    public static func getApiUrl() -> String {
        return apiUrl
    }
    
    public static func getServerUrl() -> String {
        return serverUrl
    }
    
    public static func getServiceUrl() -> String {
        return serviceUrl
    }
    
    public static func getSocketUrl() -> String {
        return socketIoUrl
    }
    
    
}
