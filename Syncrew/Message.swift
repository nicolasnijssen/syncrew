//
//  Message.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 08/03/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import Foundation

class Message {
    
    var username:String
    var messageText:String
    var chatMessage:String
    
    init(username:String, messageText:String) {
        
        self.username = username
        self.messageText = messageText
        
        self.chatMessage = "\(self.username):\n\(self.messageText)"
    }
    
    
}
