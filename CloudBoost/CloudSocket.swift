//
//  CloudSocket.swift
//  CloudBoost
//
//  Created by Randhir Singh on 24/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudSocket {
    private static var socket: SocketIOClient?
    
    public static func initialise(url: String){
        let socket = SocketIOClient(socketURL: NSURL(string: url)!, options: [.Log(true), .ForcePolling(true)])
        self.setSocket(socket)    
    }
    
    public static func getSocket() -> SocketIOClient {
        return CloudSocket.socket!
    }
    
    public static func setSocket(socket: SocketIOClient){
        CloudSocket.socket = socket
    }
    
}