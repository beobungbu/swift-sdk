//
//  CloudNotification.swift
//  CloudBoost
//
//  Created by Randhir Singh on 24/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudNotification {
    
    /**
     *
     * Start listening to events
     *
     *
     * @param channelName channel to start listening on
     * @param callback a listener which is called when the event is triggered
     * @throws CloudBoostError
     */
    public static func on(channelName: String, callback: (CloudBoostNotificationResponse)->Void) throws{
        if(CloudApp.getAppId() == nil){
            throw CloudBoostError.InvalidArgument
        }
        if(CloudApp.getAppKey() == nil){
            throw CloudBoostError.InvalidArgument
        }
        
        CloudSocket.socket!.on("connect"){ data, ack in
            print("Connected :D")
        }
        

        CloudSocket.socket!.on(CloudApp.getAppId()! + channelName, callback: {
            data, ack in
            let resp = CloudBoostNotificationResponse()
            print("YAYAYAYA")
            resp.data = data
            resp.ack = ack
            callback(resp)
            CloudSocket.getSocket().emit(CloudApp.getAppId()! + channelName, "join-custom-channel")
        })
        CloudSocket.socket?.connect()
        CloudSocket.getSocket().connect()
        CloudSocket.socket!.connect(timeoutAfter: 15, withTimeoutHandler: {
            print("Timeout")
        })
    }
    
    /**
     *
     * Write data to a channel, any client subscribed to this channel will receive a notification
     *
     * @param channelName
     * @param data
     * @throws CloudBoostError
     */
    public static func publish(channelName: String, data: AnyObject) throws{
        if(CloudApp.getAppId() == nil){
            throw CloudBoostError.InvalidArgument
        }
        if(CloudApp.getAppKey() == nil){
            throw CloudBoostError.InvalidArgument
        }
        // splitting into two strings
        let x = ["channel":CloudApp.getAppId()! + channelName, "data":data]
        let dat = try! NSJSONSerialization.dataWithJSONObject(x, options: NSJSONWritingOptions.init(rawValue: 0))
        let str = NSString(data: dat, encoding: NSUTF8StringEncoding) as! String
        CloudSocket.getSocket().emit("publish-custom-channel", str)
    }
    
    /**
     * stop listening to events
     * @param channelName channel to stop listening from
     * @param callbackObject
     * @throws CloudBoostError
     */
    public static func off(channelName: String, callback: ()->Void) throws{
        if(CloudApp.getAppId() == nil){
            throw CloudBoostError.InvalidArgument
        }
        if(CloudApp.getAppKey() == nil){
            throw CloudBoostError.InvalidArgument
        }
        
        CloudSocket.getSocket().disconnect()
        CloudSocket.getSocket().emit("leave-custom-channel", CloudApp.getAppId()! + channelName)
        CloudSocket.getSocket().disconnect()
        CloudSocket.getSocket().off(CloudApp.getAppId()! + channelName)
        
    }
    
    
}