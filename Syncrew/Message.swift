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
    
    init(username:String, messageText:String) {
        
        self.username = username
        self.messageText = messageText
    }
}
