//
//  SecondViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import JAYSON
import Alamofire

class VideoViewController: UIViewController {

    public let stream = StreamViewController()
    var urls: [URL] = []
    var room:Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
      
        self.stream.videos = room.videos
        
        self.retrieveUrls{
            
        YTFPlayer.initYTF(self.urls, tableCellNibName: "VideoCell", delegate: self.stream, dataSource: self.stream)
        YTFPlayer.showYTFView(self)
            
            
            
        }

    }
 
    func retrieveUrls(_ completed: @escaping DownloadComplete){

        for var i in (0..<room.videos.count){
            
            self.urls.append(URL(string:room.videos[i].playback)!)
            
        }
        
        completed()
    }
    
  
  }






