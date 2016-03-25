//
//  CloudCommunications.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudCommunications {
    
    public static func _request(var method: String, url: NSURL, params: NSMutableDictionary, callback: (response: CloudBoostResponse) -> Void ){
        
        //Check for logging
        let isLogging = CloudApp.isLogging()
        
        //Ready the calback response
        let cloudBoostResponse = CloudBoostResponse()
        
        //Handling DELETE request by fitting a parameter
        if(method == "DELETE"){
            params["method"] = "DELETE"
            method = "PUT"
        }
        
        //Ready the session
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        //Check params
        if(isLogging){
            print("Sending the following Object: ")
            print(params)
        }
        
        //Ready the payload by converting it to JSON
        let payload = try! params.getJSON()
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = payload
        
        //Calling Service to send data and receive response
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if((error) != nil){
                cloudBoostResponse.message = "Error occured while reaching out to server"
                callback(response: cloudBoostResponse)
            } else if(response == nil){
                cloudBoostResponse.message = "Nil response"
                callback(response: cloudBoostResponse)
            } else if(data == nil){
                cloudBoostResponse.message = "No data received"
                callback(response: cloudBoostResponse)
            } else {
                
                //Checking the response
                if(isLogging){
                    print("Response: \(response)")
                    let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Body: \(strData)")
                }
                
                //Converting to proper format and returning
                do{
                    if let httpResponse = response as? NSHTTPURLResponse {
                        cloudBoostResponse.status = httpResponse.statusCode
                        if(httpResponse.statusCode == 200){
                            cloudBoostResponse.success = true
                        }
                    }
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSMutableDictionary{
                        cloudBoostResponse.object = jsonResult
                        callback(response: cloudBoostResponse)
                    }else{
                        if(isLogging){
                            print("Could not convert the response to NSMutalbeDictionary")
                        }
                        cloudBoostResponse.message = "Error while converting to NSMutableDictionary"
                        callback(response: cloudBoostResponse)
                    }
                }catch let parseError {
                    if(isLogging){
                        print(parseError)
                    }
                    cloudBoostResponse.message = "Failed while parsing the received data"
                    callback(response: cloudBoostResponse)
                }
            }
        })
        
        task.resume()
        
    }

}