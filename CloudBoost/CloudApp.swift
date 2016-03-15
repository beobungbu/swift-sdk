//
//  CloudApp.swift
//  CloudBoost
//
//  Created by Randhir Singh on 15/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudApp: NSObject {
    
    public var appID: String?
    public var appKey: String?
    
    
    public let serverUrl = "https://api.cloudboost.io"
    public let socketIoUrl = "https://realtime.cloudboost.io"
    public let serviceUrl = "https://service.cloudboost.io"
    
    var unsavedTables = [CloudTable]()
    
    
    public init(appID: String, appKey: String){
        print("Creating a new Cloud App...")
        self.appID = appID
        self.appKey = appKey
    }
    
    public func printAppdetails(){
        print("App ID: " + appID! + "\nApp Key: " + appKey!)
    }
    
    public func saveAll(callback: (status: Int, message: String) -> Void){
        for table in unsavedTables {
            self._request("PUT", url: NSURL(string: self.socketIoUrl)!, params: table.attributes!,callback: {
                (status: Int, message: String) -> Void in
                // Do saveAll level error reporting
                callback(status: status, message: message)
            })
        }
    }
    
    public func saveTable(tableName: String, callback: (status: Int, message: String) -> Void){
        for table in unsavedTables {
            if(tableName == table.tableName){
                print("Yes! Saving " + tableName + "...")
                let url = serverUrl + "/data/" + appID! + "/" + tableName
                let params = [ "key":appKey! ] as NSDictionary
                self._request("PUT", url: NSURL(string: url)!, params: params, callback: {
                    (status: Int, message: String) -> Void in
                    // Do saveTable level error reporting
                    callback(status: status, message: message)
                })
                return
            }
        }
        callback(status: -1,message: "No table of that name found")
    }
    
    public func newTable(tableName: String, attributes: NSDictionary){
        unsavedTables.append(CloudTable(tableName: tableName, attributes: attributes))
    }
    
    func _request(method: String, url: NSURL, params: NSDictionary, callback: (status: Int, message: String) -> Void ){
    
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: (serverUrl))!)
        
        request.HTTPMethod = "POST"
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("iOS SDK", forHTTPHeaderField: "UserAgent")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Calling Service to send data and receive response
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if((error) != nil){
                callback(status: -1, message: (error?.localizedDescription)!)
            } else if(response == nil){
                callback(status: -1, message: "Failure, Invalid response received")
            } else if(data == nil){
                callback(status: -1, message: "\(response) \n Nil Data")
            } else {
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")
                do{
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        print(jsonResult)
                    }else{
                        print("Error parsing the received data!")
                    }
                }catch let parseError {
                    print(parseError)
                    
                }
            }
        })
        
        task.resume()
        
    }
    
    
}
