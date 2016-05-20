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
    public static func on(channelName: String, handler: (data: [AnyObject], ack: SocketAckEmitter)-> Void, callback: (error: String?)->Void) {
        if(CloudApp.getAppId() == nil){
            callback(error: "App ID is invalid")
        }
        if(CloudApp.getAppKey() == nil){
            callback(error: "App key is invalid")
        }
        
        // registering socket events
        CloudSocket.socket!.on("connect"){ data, ack in
            CloudSocket.getSocket().emit("join-custom-channel",CloudApp.getAppId()! + channelName)
            callback(error: nil)
        }
        // registering handler to the specified channel's event
        CloudSocket.socket!.on(CloudApp.getAppId()! + channelName, callback: handler)
        
        // connecting to the server
        CloudSocket.socket!.connect(timeoutAfter: 15, withTimeoutHandler: {
            // handling timeout, sending an error to the callback
            callback(error: "Server time out")
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
        // making the payload fot publish-custom-channel
        let channel = CloudApp.getAppId()! + channelName
        let payload = ["channel":channel, "data":data]
        CloudSocket.getSocket().emit("publish-custom-channel", payload)
    }
    
    /**
     * stop listening to events
     * @param channelName channel to stop listening from
     * @param callbackObject
     * @throws CloudBoostError
     */
    public static func off(channelName: String, callback: (error: String?)->Void) {
        if(CloudApp.getAppId() == nil){
            callback(error: "App ID is invalid")
        }
        if(CloudApp.getAppKey() == nil){
            callback(error: "App key is invalid")
        }
        
        
        CloudSocket.getSocket().emit("leave-custom-channel", CloudApp.getAppId()! + channelName)
        // replacing actual callback with a blank callback
        CloudSocket.getSocket().on(channelName, callback: {_,_ in})
        callback(error: nil)
        
        
    }
    
    
}