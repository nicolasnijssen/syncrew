//
//  SecondViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!

    var videoID: String!

    
    var videos:Array<Video>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videos = APICommunicator.instance.videos
        
        var urls: [URL] = []
        for video in videos {
            
            print(video.playback)
            urls.append(URL(string:video.playback)!)
        }

        YTFPlayer.initYTF(urls, tableCellNibName: "VideoCell", delegate: self, dataSource: self)
        YTFPlayer.showYTFView(self)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Table View Functions */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        return cell
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! VideoCell
        cell.labelArtist.text = "Unbox Therapy"
        cell.labelTitle.text = videos[indexPath.row].title
        
        if let url = NSURL(string: videos[indexPath.row].thumbnail) {
            if let data = NSData(contentsOf: url as URL) {
                cell.imageThumbnail.image = UIImage(data: data as Data)

            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        YTFPlayer.playIndex(indexPath.row)
        
        videos.remove(at: indexPath.row)
        
        tableView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}






