//
//  Song.swift
//  YouTubeFloatingPlayer
//
//  Created by Ana Paula on 6/8/16.
//  Copyright © 2016 Ana Paula. All rights reserved.
//

import UIKit
import Alamofire
import JAYSON

class Video {
    var title: String
    var youtube: String
    var playback: String

    
    init(title: String, youtube: String, playback:String) {
        self.title = title
        self.youtube = youtube
        self.playback = playback
     
        pl()
    }
    

    func pl(){
        
        
        let url = "https://helloacm.com/api/video/?cached&video=\(self.youtube)"
        
        Alamofire.request(url).responseJSON { response in
                
                
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any:json)
                
                print(jayson["url"].string!)
                
                self.playback = jayson["url"].string!
            
            }
            
        }
        

    }
}
