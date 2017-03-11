//
//  Room.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import Foundation

class Room {
    
    var id:Int
    var name: String
    var thumbnail: String
    var visibile: Bool
    var admin:Int
    
    var videos:Array<Video> = Array<Video>()
    
    
    init(id:Int,name:String,thumbnail:String, visibile:Bool,admin:Int) {
     
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.visibile = visibile
        self.admin = admin
    }
    
    
    public func addVideo(video:Video){
        
        self.videos.append(video)
    }
    
}
