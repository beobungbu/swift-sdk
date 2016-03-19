//
//  CloudCommunications.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudCommunications {
    
    public static func _request(method: String, url: NSURL, params: NSMutableDictionary, callback: (status: Int, response: String) -> Void ){
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        let payload = try! params.getJSON()
        print(url)
        print(NSString(data: payload!,encoding: NSASCIIStringEncoding))
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = payload
        
        //Calling Service to send data and receive response
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if((error) != nil){
                callback(status: -1, response: (error?.localizedDescription)!)
            } else if(response == nil){
                callback(status: -1, response: "Failure, Invalid response received")
            } else if(data == nil){
                callback(status: -1, response: "\(response) \n Nil Data")
            } else {
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")
                do{
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
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