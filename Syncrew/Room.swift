//
//  Room.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import Foundation

class Room: NSObject {
    
    var name: String?
    var type: RoomType?
    var thumbnail: String?
    
    
    init(name:String, type:RoomType,thumbnail:String) {
     
        self.name = name
        self.type = type
        self.thumbnail = thumbnail
    }
}
