//
//  APICommunicator.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import Foundation
import JAYSON
import Alamofire

class APICommunicator: NSObject {

    public static let instance = APICommunicator()
    
    var videos:Array<Video> = Array<Video>()
    
    var rooms:Array<Room> = Array<Room>()

    var pubRooms:Array<Room> = Array<Room>()
    var privRooms:Array<Room> = Array<Room>()

    let errorRoom = Room(id: 9999999, name: "ERROR", thumbnail: "ERROR", type: "ERROR")

  
    
    func retrieveRooms(){
        
        Alamofire.request("http://127.0.0.1:8000/api/rooms").responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any:json)
                
                for var i in (0..<jayson.array!.count){
                    
                    let room:Room = Room(id: jayson[i]["id"].int!,name: jayson[i]["name"].string!, thumbnail: jayson[i]["thumbnail"].string!, type: jayson[i]["room_type"].string!)
                    
                   
                    self.rooms.append(room)
                    print("+1 Room count: \(self.rooms.count)")
                    print("naam \(room.name)")
                }
                
            }
            
        }
    }
    
    
    
    func retrieveVideos(){
        
        Alamofire.request("http://127.0.0.1:8000/api/videos").responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any: json)
                
                for var i in (0..<jayson.array!.count){
                    
                    let video:Video = Video(title: jayson[i]["title"].string!, thumbnail: jayson[i]["thumbnail"].string!,youtube:jayson[i]["youtube"].string!,playback:jayson[i]["playback"].string!)
                    
                    print("Video \(video.title)")
                    self.videos.append(video)
                }
            }
        }
        
}
    
    /*
    func sortRooms(){
        
        
        for var i in (0..<self.rooms.count){

            if(rooms[i].type == "PUBLIC"){
                
                pubRooms.append(rooms[i])
            }else {
                
                privRooms.append(rooms[i])
            }
            
        }
    }
    
    
    func retrieveRoomDetails(roomId: Int) -> Room {
        
        for var i in (0..<self.rooms.count){
            
            let room = self.rooms[i]
            if (room.id == roomId){
                
                return self.rooms[i]
            }
        }
    
        return errorRoom
        
    }
    
    func retrievePublicRooms() -> NSMutableArray {
        
        return nil;
    }
    
    func retrievePrivateRooms() -> NSMutableArray {
        
        return nil;

    }
    
    
 */
    
}
