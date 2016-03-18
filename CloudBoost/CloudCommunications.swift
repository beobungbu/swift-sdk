//
//  CloudCommunications.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudCommunications {
    
    public static func _request(method: String, url: NSURL, params: NSMutableDictionary, callback: (status: Int, message: String) -> Void ){
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: (CloudApp.serverUrl))!)
        
        request.HTTPMethod = "POST"
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("iOS SDK", forHTTPHeaderField: "UserAgent")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "sessionID")
        
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