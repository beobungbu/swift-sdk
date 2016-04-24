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
        
        CloudSocket.getSocket().connect()
        CloudSocket.getSocket().on(CloudApp.getAppId()! + channelName, callback: {
            data, ack in
            let resp = CloudBoostNotificationResponse()
            resp.data = data
            resp.ack = ack
            callback(resp)
        })
        CloudSocket.getSocket().emit("join-custom-channel", CloudApp.getAppId()! + channelName)
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