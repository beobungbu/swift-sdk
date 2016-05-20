//
//  CloudQueue.swift
//  CloudBoost
//
//  Created by Randhir Singh on 18/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudQueue{
    
    static let QUEUE_TYPE = "queueType"
    
    var acl: ACL
    var document = NSMutableDictionary()
    private var subscribers = [String]()
    private var messages = [QueueMessage]()
    private var queueType = "pull"
    var timeout = 1800
    var delay = 1800
    var name: String?
    
    public init(queueName: String?, queueType: String?){
        self.acl = ACL()
        self.name = queueName
        document["subscribers"] = self.subscribers
        document["retry"] = nil
        if queueName == nil {
            document["name"] = "null"
        } else {
            document["name"] = queueName
        }
        document["_type"] = "queue"
        document["ACL"] = acl.getACL()
        document["expires"] = nil
        if queueType == nil {
            document["queueType"] = self.queueType
        } else {
            document["queueType"] = queueType
        }
        document["messages"] = nil
        
    }
    
    public func setACL(acl: ACL) {
        setAttribute("ACL", val: acl.getACL())
    }
    
    public func getACL() -> ACL? {
        if let acl = document["ACL"] as? NSMutableDictionary {
            let returnACL = ACL(acl: acl)
            return returnACL
        }
        return nil
    }
    
    public func getTimeout() -> Int? {
        if let timeout = document["timeout"] as? Int {
            return timeout
        }
        return nil
    }
    
    public func setTimeout(timeout: Int) {
        setAttribute("timeout", val: timeout)
    }
    
    public func getDelay() -> Int? {
        return document["delay"] as? Int
    }
    
    public func setDelay(delay: Int){
        setAttribute("delay", val: delay)
    }
    
    public func getExpires() -> NSDate? {
        if let strDate = document["expires"] as? String {
            return CloudBoostDateFormatter.getISOFormatter().dateFromString(strDate)
        }
        return nil
    }
    
    public func setExpires(date: NSDate) {
        document["expires"] = CloudBoostDateFormatter.getISOFormatter().stringFromDate(date)
    }
    
    public func setQueueType(type: String) {
        setAttribute("type", val: type)
    }
    
    public func getQueueType() -> String? {
        if let type = document["type"] as? String {
            return type
        }
        return nil
    }
    
    public func getSubscribers() -> [String]?{
        return document["subscribers"] as? [String]
    }
    
    public func getCreatedAt() -> NSDate? {
        if let strDate = document["createdAt"] as? String {
            let date = CloudBoostDateFormatter.getISOFormatter().dateFromString(strDate)
            return date
        }
        return nil
    }

    public func setUpdatedAt(date: NSDate){
        setAttribute("updatedAt", val: CloudBoostDateFormatter.getISOFormatter().stringFromDate(date))
    }
    
    public func getUpdatedAt() -> NSDate? {
        if let strDate = document["updatedAt"] as? String {
            let date = CloudBoostDateFormatter.getISOFormatter().dateFromString(strDate)
            return date
        }
        return nil
    }

    public func getDocument() -> NSMutableDictionary{
        return self.document
    }
    
    public func setDocument(document: NSMutableDictionary) {
        self.document = document
    }

    
    
    
    public func refreshMessageTimeout(msg: QueueMessage, callback: (CloudBoostResponse)->Void){
        let data = NSMutableDictionary()
        let id = msg.getId()!
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/\(id)/refresh-message-timeout"
        data["key"] = CloudApp.getAppKey()
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: data, callback: {
            response in
            callback(response)
        })
        
    }
    
    public func refreshMessageTimeout(msg: QueueMessage, timeout: Int, callback: (CloudBoostResponse)->Void){
        let data = NSMutableDictionary()
        let id = msg.getId()!
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/\(id)/refresh-message-timeout"
        data["key"] = CloudApp.getAppKey()
        data["timeout"] = timeout
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: data, callback: {
            response in
            callback(response)
        })
        
    }
    
    public func peekMessage(count: Int, callback: (CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/peekMessage"
        data["key"] = CloudApp.getAppKey()
        data["count"] = count
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var msgArr = [QueueMessage]()
                    for el in doc {
                        let msg = QueueMessage()
                        msg.setDocument(el)
                        msgArr.append(msg)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msgArr
                    resp.status = response.status
                    callback(resp)
                } else if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }

        })
    }
    
    public func peek(count: Int, callback: (CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/peek"
        data["key"] = CloudApp.getAppKey()
        data["count"] = count
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var msgArr = [QueueMessage]()
                    for el in doc {
                        let msg = QueueMessage()
                        msg.setDocument(el)
                        msgArr.append(msg)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msgArr
                    resp.status = response.status
                    callback(resp)
                } else if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }

        })
    }
    
    
    public func getMessage(count: Int?, callback: (CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/getMessage"
        data["key"] = CloudApp.getAppKey()
        if count == nil {
            data["count"] = 1
        }else{
            data["count"] = count
        }
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }
        })
    }

    public func deleteMessage(id: String, callback: (CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/message/\(id)"
        data["key"] = CloudApp.getAppKey()
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }

        })
    }
    
    public func deleteMessage(message: QueueMessage, callback: (CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/message/\(message.getId()!)"
        data["key"] = CloudApp.getAppKey()
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }
            
        })
    }

    
    public func getMessageById(id: String, callback: (CloudBoostResponse)->Void) {
        let data = NSMutableDictionary()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/message/\(id)"
        data["key"] = CloudApp.getAppKey()
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }
        })
    }
    
    public func addSubscriber(subscriber: AnyObject, callback: (CloudBoostResponse)->Void){
        self.subscribers = []
        if let arr = subscriber as? [String] {
            for el in arr {
                self.subscribers.append(el)
            }
        }else if let el = subscriber as? String{
            self.subscribers.append(el)
        }
        
        document["subscribers"] = subscribers
        
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/subscriber"
        
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }else{
                self.document["subscribers"] = []
            }
            callback(response)
        })
    }
    
    public func deleteSubscriber(subscriber: AnyObject, callback: (CloudBoostResponse)->Void){
        self.subscribers = []
        if let arr = subscriber as? [String] {
            for el in arr {
                self.subscribers.append(el)
            }
        }else if let el = subscriber as? String{
            self.subscribers.append(el)
        }
        
        document["subscribers"] = subscribers
        
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/subscriber"
        
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(response)
        })
    }
    
    public func removeSubscriber(subscriber: AnyObject, callback: (CloudBoostResponse)->Void){
        self.subscribers = []
        if let arr = subscriber as? [String] {
            for el in arr {
                self.subscribers.append(el)
            }
        }else if let el = subscriber as? String{
            self.subscribers.append(el)
        }
        
        document["subscribers"] = subscribers
        
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/subscriber"
        
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(response)
        })
    }

    
    public func addMessage(message: AnyObject, callback: (CloudBoostResponse) -> Void){
        self.messages = []
        if let mess = message as? [QueueMessage] {
            for el in mess {
                messages.append(el)
            }
        }
        if let mess = message as? QueueMessage {
            messages.append(mess)
        }
        if let mess = message as? [String] {
            for el in mess {
                let queueMess = QueueMessage()
                queueMess.push(el)
                messages.append(queueMess)
            }
        }
        if let mess = message as? String {
            let queueMess = QueueMessage()
            queueMess.push(mess)
            messages.append(queueMess)
        }
        
        var arr = [NSMutableDictionary]()
        for message in messages {
            arr.append(message.getDocument())
        }
        self.document["messages"] = arr
        
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/message"
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var msgArr = [QueueMessage]()
                    for el in doc {
                        let msg = QueueMessage()
                        msg.setDocument(el)
                        msgArr.append(msg)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msgArr
                    resp.status = response.status
                    callback(resp)
                } else if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }
        })
    }
    
    public func push(message: AnyObject, callback: (CloudBoostResponse) -> Void){
        self.messages = []
        if let mess = message as? [QueueMessage] {
            for el in mess {
                messages.append(el)
            }
        }
        if let mess = message as? QueueMessage {
            messages.append(mess)
        }
        if let mess = message as? [String] {
            for el in mess {
                let queueMess = QueueMessage()
                queueMess.push(el)
                messages.append(queueMess)
            }
        }
        if let mess = message as? String {
            let queueMess = QueueMessage()
            queueMess.push(mess)
            messages.append(queueMess)
        }
        
        var arr = [NSMutableDictionary]()
        for message in messages {
            arr.append(message.getDocument())
        }
        self.document["messages"] = arr
        
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/message"
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: data, callback: {
            response in
            callback(response)
        })
    }

    
    public func deleteQueue(callback: (CloudBoostResponse) -> Void){
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)"
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(response)
        })
    }
    
    public func pull(count: Int, callback: (CloudBoostResponse) -> Void) {
        let data = NSMutableDictionary()
        data["count"] = count
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/pull"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var msgArr = [QueueMessage]()
                    for el in doc {
                        let msg = QueueMessage()
                        msg.setDocument(el)
                        msgArr.append(msg)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msgArr
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }
        })
    }
    
    public func clear(callback: (CloudBoostResponse) -> Void){
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/clear"
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(response)
        })
    }
    
    public func update(callback: (CloudBoostResponse) -> Void){
        let data = NSMutableDictionary()
        setAttribute("_isModified", val: true)
        setAttribute("_modifiedColumns", val: "[\"queueType\"]")
        
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)"
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(response)
        })
    }
    
    public static func get(name: String, callback: (CloudBoostResponse) -> Void){
        let data = NSMutableDictionary()
        
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(name)"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    let msg = QueueMessage()
                    msg.setDocument(doc)
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msg
                    resp.status = response.status
                    callback(resp)
                }else{
                    callback(response)
                }
            }else{
                callback(response)
            }
        })
    }
    
    public func getAllMessages(callback: (CloudBoostResponse) -> Void) {
        let data = NSMutableDictionary()
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/messages"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var queueArr = [QueueMessage]()
                    for el in doc {
                        let queEl = QueueMessage()
                        queEl.setDocument(el)
                        queueArr.append(queEl)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = queueArr
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }
        })
    }
    
    public func delete(callback: (CloudBoostResponse) -> Void){
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)"
        CloudCommunications._request("DELETE", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(response)
        })
    }

    public func create(callback: (CloudBoostResponse) -> Void) throws{
        if self.name == nil {
            throw CloudBoostError.InvalidArgument
        }
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/create"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? NSMutableDictionary {
                    self.document = doc
                }
            }
            callback(response)
        })
    }
    
    public static func getAll(callback: (CloudBoostResponse) -> Void){
        let data = NSMutableDictionary()
        data["key"] = CloudApp.getAppKey()
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/"
        CloudCommunications._request("POST", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var queueArr = [CloudQueue]()
                    for el in doc {
                        let queEl = CloudQueue(queueName: nil,queueType: nil)
                        queEl.setDocument(el)
                        queueArr.append(queEl)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = queueArr
                    resp.status = response.status
                    callback(resp)
                } else {
                    response.message = "No queues found"
                    callback(response)
                }
            } else {
                callback(response)
            }
        })
    }
    
    public func updateMessage(message: [QueueMessage], callback: (CloudBoostResponse)->Void ) throws {
        self.messages = []
        for mess in message {
            if mess.getId() == nil {
                throw CloudBoostError.InvalidArgument
            } else {
                self.messages.append(mess)
            }
        }
        var arr = [NSMutableDictionary]()
        for message in messages {
            arr.append(message.getDocument())
        }
        self.document["messages"] = arr
        
        let data = NSMutableDictionary()
        data["document"] = self.document
        data["key"] = CloudApp.getAppKey()
        
        let url = CloudApp.getApiUrl() + "/queue/" + CloudApp.getAppId()! + "/\(self.name!)/message"
        
        CloudCommunications._request("PUT", url: NSURL(string: url)!, params: data, callback: {
            response in
            if response.status == 200 {
                if let doc = response.object as? [NSMutableDictionary] {
                    var msgArr = [QueueMessage]()
                    for el in doc {
                        let msg = QueueMessage()
                        msg.setDocument(el)
                        msgArr.append(msg)
                    }
                    let resp = CloudBoostResponse()
                    resp.success = response.success
                    resp.object = msgArr
                    resp.status = response.status
                    callback(resp)
                } else {
                    callback(response)
                }
            } else {
                callback(response)
            }

        })

    }
        
    
    // MARK: private helper functions
    
    private func setAttribute(key: String, val: AnyObject){
        document[key] = val
    }
    
    private func getElement(key: String) -> AnyObject? {
        return document[key]
    }

    
}