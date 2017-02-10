//
//  Song.swift
//  YouTubeFloatingPlayer
//
//  Created by Ana Paula on 6/8/16.
//  Copyright © 2016 Ana Paula. All rights reserved.
//

import UIKit

class Video {
    var title: String
    var thumbnail: String
    var youtube: String
    var playback: String

    
    init(title: String, thumbnail: String, youtube: String, playback:String) {
        self.title = title
        self.thumbnail = thumbnail
        self.youtube = youtube
        self.playback = playback
    }
}
