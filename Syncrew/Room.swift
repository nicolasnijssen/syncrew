//
//  Room.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import Foundation

class Room: NSObject {
    
    var id:Int
    var name: String
    var thumbnail: String
    var type: String
    
    
    init(id:Int,name:String,thumbnail:String, type:String) {
     
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.type = type
    }
}
