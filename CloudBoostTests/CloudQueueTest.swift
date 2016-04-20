//
//  CloudQueueTest.swift
//  CloudBoost
//
//  Created by Randhir Singh on 19/04/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import XCTest
@testable import CloudBoost

class CloudQueueTest: XCTestCase {

    override func setUp() {
        super.setUp()
        let app = CloudApp.init(appID: "xckzjbmtsbfb", appKey: "345f3324-c73c-4b15-94b5-9e89356c1b4e")
        app.setIsLogging(true)
        app.setMasterKey("f5cc5cb3-ba0d-446d-9e51-e09be23c540d")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Should return no queue objects when there are no queues inthe database
    func testGetAllWithNoQueueInDatabase(){
        let exp = expectationWithDescription("return no queue on an empty database")
        CloudQueue.getAll({
            response in
            response.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should get the message when expires is set to future date.
    func testGetMessageExpireSetToFuture(){
        let exp = expectationWithDescription("get message when expire set to future date")
        let today = NSDate()
        let tomorrow = NSDate(timeIntervalSinceReferenceDate: today.timeIntervalSinceReferenceDate + 60*60*24)
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let queueMessage = QueueMessage()
        queueMessage.setExpires(tomorrow)
        queueMessage.setMessage("data")
        
        queue.addMessage(queueMessage, callback: {
            response in
            response.log()
            if response.success {
                queue.getMessage(1, callback: {
                    response in
                    response.log()
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }
    
    // Should add data into the Queue
    func testAddDataInQueue(){
        let exp = expectationWithDescription("add data into the queue")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        queue.addMessage("Randhir", callback: {
            response in
            response.log()
            if let res = response.object as? NSMutableDictionary {
                let queMessage = QueueMessage()
                queMessage.setDocument(res)
                if queMessage.getMessage()! == "Randhir" {
                    print("Data matches")
                }else{
                    XCTAssert(false)
                }
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // create and delete a queue
    func testCreateDeleteQueue(){
        let exp = expectationWithDescription("create and delete queue")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        try! queue.create({
            response in
            if response.success {
                queue.delete({
                    response in
                    XCTAssert(response.success)
                    exp.fulfill()
                })
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should add expires into the queue message.
    func testAddExpiresToData(){
        let exp = expectationWithDescription("add expires field to queue messages")
        let today = NSDate()
        let tomorrow = NSDate(timeIntervalSinceReferenceDate: today.timeIntervalSinceReferenceDate + 60*60*24)
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let queueMessage = QueueMessage()
        queueMessage.setExpires(tomorrow)
        queueMessage.setMessage("data")
        
        queue.addMessage(queueMessage, callback: {
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }

    // Should add current time as expires into the queue
    func testAddCurrentTimeExpires(){
        let exp = expectationWithDescription("add current time as expires in queue messages")
        let today = NSDate()
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let queueMessage = QueueMessage()
        queueMessage.setExpires(today)
        queueMessage.setMessage("data")
        
        queue.addMessage(queueMessage, callback: {
            response in
            response.log()
            XCTAssert(response.success)
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should add multiple messages and get all messages
    func testAddMultipleMessages(){
        let exp = expectationWithDescription("add multiple messages in a queue")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        // Addding first message
        queue.addMessage("sample", callback: {
            response in
            response.log()
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "sample" {
                    // Add the second message
                    queue.addMessage("sample1", callback: {
                        response in
                        if let res = response.object as? QueueMessage {
                            if res.getMessage()! == "sample1" {
                                // now get the entire queue
                                queue.getAllMessages({
                                    response in
                                    response.log()
                                    if let queueMessages = response.object as? [QueueMessage] {
                                        if queueMessages.count == 2 {
                                            XCTAssert(true)
                                        }else{
                                            XCTAssert(false)
                                        }
                                    }
                                    exp.fulfill()
                                })
                            }else{
                                XCTAssert(false)
                            }
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should update data into the Queue
    func testUpdateData(){
        let exp = expectationWithDescription("update data in queue")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        // Addding message
        let message = "sample"
        queue.addMessage(message, callback: {
            response in
            response.log()
            if let res = response.object as? NSMutableDictionary {
                let queMessage = QueueMessage()
                queMessage.setDocument(res)
                if queMessage.getMessage()! == message {
                    // Update the message
                    let message2 = "Sample2"
                    queMessage.setMessage(message2)
                    try! queue.updateMessage([queMessage], callback: {
                        response in
                        if let res = response.object as? NSMutableDictionary {
                            let queMessage = QueueMessage()
                            queMessage.setDocument(res)
                            if queMessage.getMessage()! == message2 {
                                XCTAssert(true)
                            }else{
                                XCTAssert(false)
                            }
                            exp.fulfill()
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should not update data in the queue which is not saved
    func testUpdateUnsavedData(){
        let exp = expectationWithDescription("should not update unsaved data")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Sample")
        do{
            try queue.updateMessage([message], callback: {
                response in
                response.log()
                XCTAssert(false)
                exp.fulfill()
            })
        } catch {
            print("Error in arguments")
            XCTAssert(true)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    // should create the queue
    func testCreateQueue(){
        let exp = expectationWithDescription("should create the queue")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        try! queue.create({
            response in
            if queue.getCreatedAt() != nil && queue.getUpdatedAt() != nil {
                print("Queue created successfully")
            }else{
                XCTAssert(response.success)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should add an array into the queue
    func testAddArrayInQueue(){
        let exp = expectationWithDescription("add an array to queue")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        queue.addMessage(["sample","sample2"], callback: {
            response in
            let queueArr = response.object as! [QueueMessage]
            if queueArr.count == 2{
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }
    
    // can add multiple messages in the same queue
    func testAddMultipleMessagesSameQueue(){
        let exp = expectationWithDescription("add multiple messages in the same queue")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        // Addding message
        queue.addMessage(["sample","sample1"], callback: {
            response in
            response.log()
            if let res = response.object as? [QueueMessage] {
                if res.count == 2 {
                    
                    queue.addMessage(["sample3","sample4"], callback: {
                        response in
                        if let res = response.object as? [QueueMessage] {
                            if res.count == 2 {
                                queue.getAllMessages({
                                    response in
                                    if let res = response.object as? [QueueMessage] {
                                        if res.count == 4 {
                                            XCTAssert(true)
                                        }else{
                                            XCTAssert(false)
                                        }
                                        exp.fulfill()
                                    }else{
                                        XCTAssert(false)
                                    }
                                    exp.fulfill()
                                })
                            }else{
                                XCTAssert(false)
                                exp.fulfill()
                            }
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should not add null data into the Queue
    func testShouldNotAddNullData(){
        let exp = expectationWithDescription("should not add null data into the queue")
        let qName = Util.makeString(5)
        let q = CloudQueue(queueName: qName, queueType: nil)
        q.addMessage("", callback: {
            response in
            response.log()
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    //should not create queue with an empty name
    func testCreateQueueEmptyName(){
        let exp = expectationWithDescription("should not create a queue with an empty name")
        let queue = CloudQueue(queueName: nil, queueType: nil)
        do {
            try queue.create({
                response in
                response.log()
                XCTAssert(response.success)
                exp.fulfill()
            })
        } catch {
            print("stopped due to passing nil as queue name")
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should add and get data from the queue
    func testAddAndGetData(){
        let exp = expectationWithDescription("add and get data from the queue")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        // Addding message
        queue.addMessage("sample", callback: {
            response in
            response.log()
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "sample" {
                    queue.getAllMessages({
                        response in
                        if let res = response.object as? [QueueMessage] {
                            if res.count == 1 && res[0].getMessage()! == "sample"{
                                XCTAssert(true)
                            }else{
                                XCTAssert(false)
                            }
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                        exp.fulfill()
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should peek
    func testShouldPeek(){
        let exp = expectationWithDescription("should peek")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("data")
        queue.addMessage(message, callback: {
            response in
            let mes = response.object as! QueueMessage
            if mes.getMessage()! == "data" {
                queue.peekMessage(1, callback: {
                    response in
                    let mess = response.object as! QueueMessage
                    if mess.getMessage()! == "data" {
                        XCTAssert(true)
                    }else{
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should get the messages in FIFO
    func testGetMessageInFIFO(){
        let exp = expectationWithDescription("get message in FIFO fashion")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        // Addding first message
        queue.addMessage("sample", callback: {
            response in
            response.log()
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "sample" {
                    // Add the second message
                    queue.addMessage("sample1", callback: {
                        response in
                        if let res = response.object as? QueueMessage {
                            if res.getMessage()! == "sample1" {
                                // now get the entire queue
                                queue.getMessage(nil,callback: {
                                    response in
                                    let mess = response.object as! QueueMessage
                                    if mess.getMessage()! == "sample" {
                                        queue.getMessage(nil, callback: {
                                            response in
                                            let mess = response.object as! QueueMessage
                                            if mess.getMessage()! == "sample1" {
                                                print("data matches")
                                                XCTAssert(true)
                                            }
                                            else{
                                                XCTAssert(false)
                                            }
                                            exp.fulfill()
                                        })
                                    }else{
                                        XCTAssert(false)
                                        exp.fulfill()
                                    }
                                })
                            }else{
                                XCTAssert(false)
                                exp.fulfill()
                            }
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)

    }
    
    
    // Should peek 2 messages at the same time
    func testPeekTwoMessages(){
        let exp = expectationWithDescription("peek two messages at the same time")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        // Addding first message
        queue.addMessage("sample", callback: {
            response in
            response.log()
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "sample" {
                    // Add the second message
                    queue.addMessage("sample1", callback: {
                        response in
                        if let res = response.object as? QueueMessage {
                            if res.getMessage()! == "sample1" {
                                // now get the entire queue
                                queue.peekMessage(2, callback: {
                                    response in
                                    let messArr = response.object as! [QueueMessage]
                                    if messArr.count == 2 {
                                        print("count matches")
                                        XCTAssert(true)
                                    }else{
                                        XCTAssert(false)
                                    }
                                    exp.fulfill()
                                })
                                
                            }else{
                                XCTAssert(false)
                                exp.fulfill()
                            }
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    // Should get 2 messages at the same time
    func testGetTwoMessages(){
        let exp = expectationWithDescription("get two messages at the same time")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        // Addding first message
        queue.addMessage("sample", callback: {
            response in
            response.log()
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "sample" {
                    // Add the second message
                    queue.addMessage("sample1", callback: {
                        response in
                        if let res = response.object as? QueueMessage {
                            if res.getMessage()! == "sample1" {
                                // now get the entire queue
                                queue.getMessage(2, callback: {
                                    response in
                                    let messArr = response.object as! [QueueMessage]
                                    if messArr.count == 2 {
                                        print("count matches")
                                        XCTAssert(true)
                                    }else{
                                        XCTAssert(false)
                                    }
                                    exp.fulfill()
                                })
                                
                            }else{
                                XCTAssert(false)
                                exp.fulfill()
                            }
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(60, handler: nil)

    }
    
    // Should not getMessage message with the delay 
    func testNoMessageWithDelay(){
        let exp = expectationWithDescription("should not get message with delay")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        message.setDelay(3000)
        // Addding first message
        queue.addMessage(message, callback: {
            response in
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "Anurag" {
                    queue.getMessage(nil, callback: {
                        response in
                        if let _ = response.object as? QueueMessage {
                            XCTAssert(false)
                        }
                        exp.fulfill()
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should give an error if queue doesnot exists.
    func testEmptyQueue(){
        let exp = expectationWithDescription("should try getmessages on an empty queue")
        
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        queue.getMessage(1, callback: {
            response in
            if let _ = response.object as? QueueMessage {
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // should not get the same message twice
    func testGetMessageTwice(){
        let exp = expectationWithDescription("should not get message with delay")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        queue.addMessage(message, callback: {
            response in
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "Anurag" {
                    queue.getMessage(nil, callback: {
                        response in
                        if let mess = response.object as? QueueMessage {
                            if mess.getMessage()! == "Anurag" {
                                queue.getMessage(nil, callback: {
                                    response in
                                    if let _ = response.object as? QueueMessage {
                                        XCTAssert(false)
                                    }else{
                                        print("not retrieved twice")
                                        XCTAssert(true)
                                    }
                                    exp.fulfill()
                                })
                            }else{
                                XCTAssert(false)
                                exp.fulfill()
                            }
                        }else{
                            XCTAssert(false)
                            exp.fulfill()
                        }
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should be able to get messages after the delay
    func testGetMessageAfterDelay(){
        let exp = expectationWithDescription("should get message after delay")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        message.setDelay(1)
        // Addding first message
        queue.addMessage(message, callback: {
            response in
            if let res = response.object as? QueueMessage {
                if res.getMessage()! == "Anurag" {
                    queue.getMessage(nil, callback: {
                        response in
                        if let _ = response.object as? QueueMessage {
                            XCTAssert(true)
                        }else{
                            XCTAssert(false)
                        }
                        exp.fulfill()
                    })
                }else{
                    XCTAssert(false)
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should be able to get message with an id
    func testGetMessageWithID(){
        let exp = expectationWithDescription("should get message with ID")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        // Addding first message
        queue.addMessage(message, callback: {
            response in
            if let res = response.object as? QueueMessage {
                queue.getMessageById(res.getId()!, callback: {
                    response in
                    if let resp = response.object as? QueueMessage {
                        if resp.getMessage() == "Anurag"{
                            print("Matching data")
                            XCTAssert(true)
                        }else{
                            XCTAssert(false)
                        }
                    }else{
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should get null when invalid message id is requested
    func testGetMessageWithInvalidID(){
        let exp = expectationWithDescription("should not message with invalid ID")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        // Addding first message
        queue.addMessage(message, callback: {
            response in
            if let _ = response.object as? QueueMessage {
                queue.getMessageById(Util.makeString(5), callback: {
                    response in
                    if let _ = response.object as? QueueMessage {
                        XCTAssert(false)
                    }else{
                        print("nothing retrieved")
                        XCTAssert(true)
                    }
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)

    }

    // Should delete message with message id
    func testDeleteItemWithMessageID(){
        let exp = expectationWithDescription("should delete message with ID")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        // Addding first message
        queue.addMessage(message, callback: {
            response in
            if let res = response.object as? QueueMessage {
                queue.deleteMessage(res.getId()!, callback: {
                    response in
                    if let resp = response.object as? QueueMessage {
                        if resp.getId()! == res.getId()!{
                            print("Matching IDs, data deleted")
                            XCTAssert(true)
                        }else{
                            XCTAssert(false)
                        }
                    }else{
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should delete message by passing queueMessage to the function
    func testDeleteItemWithMessageObject(){
        let exp = expectationWithDescription("should delete message with queueMessage Object")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        // Addding first message
        queue.addMessage(message, callback: {
            response in
            if let res = response.object as? QueueMessage {
                queue.deleteMessage(res, callback: {
                    response in
                    if let resp = response.object as? QueueMessage {
                        if resp.getId()! == res.getId()!{
                            print("Matching IDs, data deleted")
                            XCTAssert(true)
                        }else{
                            XCTAssert(false)
                        }
                    }else{
                        XCTAssert(false)
                    }
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should not get the message after it was deleted
    func testGettingDeletedMessage(){
        let exp = expectationWithDescription("should not get message that have been deleted")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        let message = QueueMessage()
        message.setMessage("Anurag")
        // Addding first message
        queue.addMessage(message, callback: {
            response in
            if let res = response.object as? QueueMessage {
                queue.deleteMessage(res, callback: {
                    response in
                    if let resp = response.object as? QueueMessage {
                        queue.getMessageById(resp.getId()!, callback: {
                            response in
                            if let _ = response.object as? QueueMessage {
                                XCTAssert(false)
                            }else{
                                print("nothing retrieved")
                                XCTAssert(true)
                            }
                            exp.fulfill()
                        })
                    }else{
                        XCTAssert(false)
                        exp.fulfill()
                    }
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should add subscriber to the queue
    func testAddSubscriber(){
        let exp = expectationWithDescription("Should add subscriber to the queue")
        let qName = Util.makeString(5)
        let queue = CloudQueue(queueName: qName, queueType: nil)
        let url = "http://sample.sample.com"
        queue.addSubscriber(url, callback: {
            response in
            let subs = queue.getSubscribers()!
            if subs.indexOf(url) != nil {
                print("Element exists")
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }


    // Should multiple subscribers to the queue
    func testAddMultipleSubscriber(){
        let exp = expectationWithDescription("Should add multiple subscriber to the queue")
        let qName = Util.makeString(5)
        let queue = CloudQueue(queueName: qName, queueType: nil)
        let url = ["http://sample.sample.com", "http://sample1.cloudapp.net"]
        queue.addSubscriber(url, callback: {
            response in
            let subs = queue.getSubscribers()!
            if subs.indexOf(url[0]) != nil && subs.indexOf(url[1]) != nil {
                print("Element exists")
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should remove subscriber from the queue
    func testRemoveSubscriber(){
        let exp = expectationWithDescription("Should remove subscriber from the queue")
        let qName = Util.makeString(5)
        let queue = CloudQueue(queueName: qName, queueType: nil)
        let url = "http://sample.sample.com"
        queue.removeSubscriber(url, callback: {
            response in
            let subs = queue.getSubscribers()!
            if subs.indexOf(url) != nil {
                print("Element exists, fail")
                XCTAssert(false)
            }else{
                XCTAssert(true)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should remove multiple subscriber from the queue
    func testRemoveMultipleSubscriber(){
        let exp = expectationWithDescription("Should remove multiple subscriber from the queue")
        let qName = Util.makeString(5)
        let queue = CloudQueue(queueName: qName, queueType: nil)
        let url = ["http://sample.sample.com", "http://sample1.cloudapp.net"]
        queue.removeSubscriber(url, callback: {
            response in
            let subs = queue.getSubscribers()!
            if subs.indexOf(url[0]) != nil && subs.indexOf(url[1]) != nil {
                print("Element exists, fail")
                XCTAssert(false)
            }else{
                XCTAssert(true)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should not add subscriber with invalid URL
    func testAddInvalidSubscriber(){
        let exp = expectationWithDescription("Should add subscriber to the queue")
        let qName = Util.makeString(5)
        let queue = CloudQueue(queueName: qName, queueType: nil)
        let url = "sample,sample"
        queue.addSubscriber(url, callback: {
            response in
            let subs = queue.getSubscribers()!
            if subs.indexOf(url) != nil {
                print("Element added, fail")
                XCTAssert(false)
            }else{
                XCTAssert(true)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should add a subscriber and then remove a subscriber from the queue
    func testAddRemoveSubscriber(){
        let exp = expectationWithDescription("Should add subscriber to the queue")
        let qName = Util.makeString(5)
        let queue = CloudQueue(queueName: qName, queueType: nil)
        let url = "http://sample.sample.com"
        queue.addSubscriber(url, callback: {
            response in
            let subs = queue.getSubscribers()!
            if subs.indexOf(url) != nil {
                queue.removeSubscriber(url, callback: {
                    response in
                    if let subs = queue.getSubscribers() {
                        if subs.indexOf(url) != nil {
                            XCTAssert(false)
                        }else{
                            print("Removed subscriber!!")
                        }
                        exp.fulfill()
                    }else{
                        XCTAssert(false)
                        exp.fulfill()
                    }
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should delete the queue
    func testDeleteQueue(){
        let exp = expectationWithDescription("should delete queue")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        queue.addMessage("sample", callback: {
            response in
            let qmess = response.object as! QueueMessage
            if qmess.getMessage()! == "sample"{
                queue.delete({
                    response in
                    XCTAssert(response.success)
                    queue.getMessage(1, callback: {
                        response in
                        if let _ = response.object as? QueueMessage {
                            XCTAssert(false)
                        }else{
                            print("nothing found in queue")
                            XCTAssert(true)
                        }
                        exp.fulfill()
                    })

                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // should clear queue
    func testClearQueue(){
        let exp = expectationWithDescription("should clear queue")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        queue.addMessage("sample", callback: {
            response in
            let qmess = response.object as! QueueMessage
            if qmess.getMessage()! == "sample"{
                queue.clear({
                    response in
                    XCTAssert(response.success)
                    queue.getMessage(1, callback: {
                        response in
                        if let _ = response.object as? QueueMessage {
                            XCTAssert(false)
                        }else{
                            print("nothing found in queue")
                            XCTAssert(true)
                        }
                        exp.fulfill()
                    })
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should get the queue
    func testShouldGetQueue(){
        let exp = expectationWithDescription("should get the queue")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        queue.addMessage("sample", callback: {
            response in
            let qmess = response.object as! QueueMessage
            if qmess.getMessage()! == "sample"{
                CloudQueue.get(queueName,callback: {
                    response in
                    XCTAssert(response.success)
                    response.log()
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Should not get the queue with null name
    func testGetQueueWithNullName(){
        let exp = expectationWithDescription("should not get the queue with invalid name")
        let queueName = Util.makeString(5)
        let queue = CloudQueue(queueName: queueName, queueType: nil)
        
        queue.addMessage("sample", callback: {
            response in
            let qmess = response.object as! QueueMessage
            if qmess.getMessage()! == "sample"{
                CloudQueue.get("null",callback: {
                    response in
                    if response.success {
                        XCTAssert(false)
                    }else{
                        XCTAssert(true)
                    }
                    response.log()
                    exp.fulfill()
                })
            }else{
                XCTAssert(false)
                exp.fulfill()
            }
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }

    // Should get All Queues
    func testGetAllQueues(){
        let exp = expectationWithDescription("should get all queues")
        CloudQueue.getAll({
            response in
            if let queues = response.object as? [CloudQueue] {
                print("Number of queues: \(queues.count)")
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}
