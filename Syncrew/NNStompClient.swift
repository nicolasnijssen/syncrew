//
//  NNStompClient.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 10/03/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit
import Foundation
import Starscream

struct StompCommands {
    static let commandConnect = "CONNECT"
    static let commandSend = "SEND"
    static let commandSubscribe = "SUBSCRIBE"
    static let commandUnsubscribe = "UNSUBSCRIBE"
    static let commandBegin = "BEGIN"
    static let commandCommit = "COMMIT"
    static let commandAbort = "ABORT"
    static let commandAck = "ACK"
    static let commandDisconnect = "DISCONNECT"
    static let commandPing = "\n"
    
    static let controlChar = String(format: "%C", arguments: [0x00])
    
    static let ackClient = "client"
    static let ackAuto = "auto"
    
    static let commandHeaderReceipt = "receipt"
    static let commandHeaderDestination = "destination"
    static let commandHeaderDestinationId = "id"
    static let commandHeaderContentLength = "content-length"
    static let commandHeaderContentType = "content-type"
    static let commandHeaderAck = "ack"
    static let commandHeaderTransaction = "transaction"
    static let commandHeaderMessageId = "message-id"
    static let commandHeaderSubscription = "subscription"
    static let commandHeaderDisconnected = "disconnected"
    static let commandHeaderHeartBeat = "heart-beat"
    static let commandHeaderAcceptVersion = "accept-version"
    
    static let responseHeaderSession = "session"
    static let responseHeaderReceiptId = "receipt-id"
    static let responseHeaderErrorMessage = "message"
    
    static let responseFrameConnected = "CONNECTED"
    static let responseFrameMessage = "MESSAGE"
    static let responseFrameReceipt = "RECEIPT"
    static let responseFrameError = "ERROR"
}

public enum NNStompAckMode {
    case AutoMode
    case ClientMode
}

public protocol NNStompClientDelegate {
    
    func stompClient(client: NNStompClient!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, withHeader header:[String:String]?, withDestination destination: String)
    
    func stompClientDidDisconnect(client: NNStompClient!)
    func stompClientWillDisconnect(client: NNStompClient!, withError error: NSError)
    func stompClientDidConnect(client: NNStompClient!)
    func serverDidSendReceipt(client: NNStompClient!, withReceiptId receiptId: String)
    func serverDidSendError(client: NNStompClient!, withErrorMessage description: String, detailedErrorMessage message: String?)
    func serverDidSendPing()
}



public class NNStompClient: NSObject, WebSocketDelegate {
    var socket: WebSocket?
    var sessionId: String?
    var delegate: NNStompClientDelegate?
    var connectionHeaders: [String: String]?
    public var certificateCheckEnabled = false
    
    private var socketUrl: URL?
    
    public func sendJSONForDict(dict: AnyObject, toDestination destination: String) {
        do {
            let theJSONData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.utf8)
            //print(theJSONText!)
            let header = [StompCommands.commandHeaderContentType:"application/json;charset=UTF-8"]
            sendMessage(message: theJSONText!, toDestination: destination, withHeaders: header, withReceipt: nil)
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    public func openSocketWithURL(url: URL, delegate: NNStompClientDelegate) {
        self.delegate = delegate
        self.socketUrl = url
        
        openSocket()
    }
    
    public func openSocketWithURL(url: URL, delegate: NNStompClientDelegate, connectionHeaders: [String: String]?) {
        self.connectionHeaders = connectionHeaders
        openSocketWithURL(url: url, delegate: delegate)
    }
    
    private func openSocket() {
        if socket == nil || !(socket?.isConnected)! {
            socket = WebSocket(url: socketUrl!)
            socket!.delegate = self
            socket!.connect()
        }
    }
    
    private func connect() {
        if (socket?.isConnected)! {
            self.sendFrame(command: StompCommands.commandConnect, header: connectionHeaders, body: nil)
        } else {
            self.openSocket()
        }
    }

    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {

        func processString(string: String) {
            var contents = string.components(separatedBy: "\n")
            if contents.first == "" {
                contents.removeFirst()
            }
            
            if let command = contents.first {
                var headers = [String: String]()
                var body = ""
                var hasHeaders  = false
                
                contents.removeFirst()
                for line in contents {
                    if hasHeaders == true {
                        body += line
                    } else {
                        if line == "" {
                            hasHeaders = true
                        } else {
                            let parts = line.components(separatedBy: ":")
                            if let key = parts.first {
                                headers[key] = parts.last
                            }
                        }
                    }
                }
                
                //remove garbage from body
                if body.hasSuffix("\0") {
                    body = body.replacingOccurrences(of: "\0", with: "")
                }
                
                receiveFrame(command:command, headers: headers, body: body)
            }
        }
        
        
        processString(string: text)
        

    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
     
        print("didCloseWithCode \(error?.code), reason: \(error?.description)")
    
        if let delegate = delegate {
            DispatchQueue.main.async(execute: {
                delegate.stompClientDidDisconnect(client: self)
            })
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
     
        func processString(string: String) {
            var contents = string.components(separatedBy: "\n")
            if contents.first == "" {
                contents.removeFirst()
            }
            
            if let command = contents.first {
                var headers = [String: String]()
                var body = ""
                var hasHeaders  = false
                
                contents.removeFirst()
                for line in contents {
                    if hasHeaders == true {
                        body += line
                    } else {
                        if line == "" {
                            hasHeaders = true
                        } else {
                            let parts = line.components(separatedBy: ":")
                            if let key = parts.first {
                                headers[key] = parts.last
                            }
                        }
                    }
                }
                
                //remove garbage from body
                if body.hasSuffix("\0") {
                    body = body.replacingOccurrences(of: "\0", with: "")
                }
                
                receiveFrame(command:command, headers: headers, body: body)
            }
        }
        
            if let msg = String(data: data, encoding: String.Encoding.utf8) {
                processString(string: msg)
            }
        
    }
    
    public func websocketDidConnect(socket: WebSocket) {
        
        print("WEBSOCKET CONNECTED")
        connect()
    }
    
    private func sendFrame(command: String?, header: [String: String]?, body: AnyObject?) {
        if (socket?.isConnected)! {
            var frameString = ""
            if command != nil {
                frameString = command! + "\n"
            }
            
            if let header = header {
                for (key, value) in header {
                    frameString += key
                    frameString += ":"
                    frameString += value
                    frameString += "\n"
                }
            }
            
            if let body = body as? String {
                frameString += "\n"
                frameString += body
            } else if let _ = body as? NSData {
                //ak, 20151015: do we need to implemenet this?
            }
            
            if body == nil {
                frameString += "\n"
            }
            
            frameString += StompCommands.controlChar
            
            if (socket?.isConnected)! {
                socket?.write(string: frameString)
            } else {
                print("no socket connection")
                if let delegate = delegate {
                    DispatchQueue.main.async(execute: {
                        delegate.stompClientDidDisconnect(client: self)
                    })
                }
            }
        }
    }
    
    private func destinationFromHeader(header: [String: String]) -> String {
        for (key, _) in header {
            if key == "destination" {
                let destination = header[key]!
                return destination
            }
        }
        return ""
    }
    
    private func dictForJSONString(jsonStr: String?) -> AnyObject? {
        if let jsonStr = jsonStr {
            do {
                if let data = jsonStr.data(using: String.Encoding.utf8) {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    return json as AnyObject?
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        return nil
    }
    
    private func receiveFrame(command: String, headers: [String: String], body: String?) {
        
        if command == StompCommands.responseFrameConnected {
            // Connected
            if let sessId = headers[StompCommands.responseHeaderSession] {
                sessionId = sessId
            }
            
            if let delegate = delegate {
                DispatchQueue.main.async(execute: {
                    delegate.stompClientDidConnect(client: self)
                })
            }
        } else if command == StompCommands.responseFrameMessage {
            // Response
            if headers["content-type"]?.lowercased().range(of: "application/json") != nil {
                if let delegate = delegate {
                    DispatchQueue.main.async(execute: {
                        delegate.stompClient(client: self, didReceiveMessageWithJSONBody: self.dictForJSONString(jsonStr: body), withHeader: headers, withDestination: self.destinationFromHeader(header: headers))
                    })
                }
            } else {
            }
        } else if command == StompCommands.responseFrameReceipt {
            // Receipt
            if let delegate = delegate {
                if let receiptId = headers[StompCommands.responseHeaderReceiptId] {
                    DispatchQueue.main.async(execute: {
                        delegate.serverDidSendReceipt(client: self, withReceiptId: receiptId)
                    })
                }
            }
        } else if command.characters.count == 0 {
            // Pong from the server
            socket?.write(string:StompCommands.commandPing)
            
            if let delegate = delegate {
                DispatchQueue.main.async(execute: {
                    delegate.serverDidSendPing()
                })
            }
        } else if command == StompCommands.responseFrameError {
            // Error
            if let delegate = delegate {
                if let msg = headers[StompCommands.responseHeaderErrorMessage] {
                    DispatchQueue.main.async(execute: {
                        delegate.serverDidSendError(client: self, withErrorMessage: msg, detailedErrorMessage: body)
                    })
                }
            }
        }
    }
    
    public func sendMessage(message: String, toDestination destination: String, withHeaders headers: [String: String]?, withReceipt receipt: String?) {
        var headersToSend = [String: String]()
        if let headers = headers {
            headersToSend = headers
        }
        
        
        headersToSend[StompCommands.commandHeaderDestination] = destination
        
        // Setting up the content length.
        let contentLength = message.utf8.count
        headersToSend[StompCommands.commandHeaderContentLength] = "\(contentLength)"
        
 
        
        sendFrame(command: StompCommands.commandSend, header: headersToSend, body: message as AnyObject?)
    }
    
    public func subscribeToDestination(destination: String) {
        subscribeToDestination(destination:destination, withAck: .AutoMode)
    }
    
    public func subscribeToDestination(destination: String, withAck ackMode: NNStompAckMode) {
        var ack = ""
        switch ackMode {
        case NNStompAckMode.ClientMode:
            ack = StompCommands.ackClient
            break
        default:
            ack = StompCommands.ackAuto
            break
        }
        
        let headers = [StompCommands.commandHeaderDestination: destination, StompCommands.commandHeaderAck: ack, StompCommands.commandHeaderDestinationId: ""]
        
        self.sendFrame(command: StompCommands.commandSubscribe, header: headers, body: nil)
    }
    
    public func subscribeToDestination(destination: String, withHeader header: [String: String]) {
        
        var headerToSend = header
        headerToSend[StompCommands.commandHeaderDestination] = destination
        sendFrame(command: StompCommands.commandSubscribe, header: headerToSend, body: nil)
    }
    
    public func unsubscribeFromDestination(destination: String) {
        var headerToSend = [String: String]()
        headerToSend[StompCommands.commandHeaderDestinationId] = destination
        sendFrame(command: StompCommands.commandUnsubscribe, header: headerToSend, body: nil)
    }
    
    public func begin(transactionId: String) {
        var headerToSend = [String: String]()
        headerToSend[StompCommands.commandHeaderTransaction] = transactionId
        sendFrame(command: StompCommands.commandBegin, header: headerToSend, body: nil)
    }
    
    public func commit(transactionId: String) {
        var headerToSend = [String: String]()
        headerToSend[StompCommands.commandHeaderTransaction] = transactionId
        sendFrame(command: StompCommands.commandCommit, header: headerToSend, body: nil)
    }
    
    public func abort(transactionId: String) {
        var headerToSend = [String: String]()
        headerToSend[StompCommands.commandHeaderTransaction] = transactionId
        sendFrame(command: StompCommands.commandAbort, header: headerToSend, body: nil)
    }
    
    public func ack(messageId: String) {
        var headerToSend = [String: String]()
        headerToSend[StompCommands.commandHeaderMessageId] = messageId
        sendFrame(command: StompCommands.commandAck, header: headerToSend, body: nil)
    }
    
    public func ack(messageId: String, withSubscription subscription: String) {
        var headerToSend = [String: String]()
        headerToSend[StompCommands.commandHeaderMessageId] = messageId
        headerToSend[StompCommands.commandHeaderSubscription] = subscription
        sendFrame(command: StompCommands.commandAck, header: headerToSend, body: nil)
    }
    
    public func disconnect() {
        var headerToSend = [String: String]()
        headerToSend[StompCommands.commandDisconnect] = String(Int(NSDate().timeIntervalSince1970))
        sendFrame(command: StompCommands.commandDisconnect, header: headerToSend, body: nil)
    }
}



