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

    
    init(title: String, youtube: String) {
        self.title = title
        self.youtube = youtube
        self.playback = ""
     
        getPlayback()
    }
    

    func getPlayback(){
        
        
        let url = "https://helloacm.com/api/video/?cached&video=\(self.youtube)"
        
        Alamofire.request(url).responseJSON { response in
                
                
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any:json)
                                
                self.playback = jayson["url"].string!
            
            }
            
        }
        

    }
}
