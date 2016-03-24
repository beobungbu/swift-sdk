//
//  CloudCommunications.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudCommunications {
    
    public static func _request(method: String, url: NSURL, params: NSMutableDictionary, callback: (response: CloudBoostResponse) -> Void ){
        
        //Ready the calback response
        let cloudBoostResponse = CloudBoostResponse()
        cloudBoostResponse.success = false
        
        //Ready the session
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        //Check params
        print(params)
        
        //Ready the payload by converting it to JSON
        let payload = try! params.getJSON()
        request.HTTPMethod = "PUT"
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
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")
                do{
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSMutableDictionary{
                        cloudBoostResponse.success = true
                        cloudBoostResponse.message = "Saved"
                        cloudBoostResponse.object = jsonResult
                        callback(response: cloudBoostResponse)
                        
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