//
//  StreamViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 15/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var videos:Array<Video> = Array<Video>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.labelTitle.text = self.videos[indexPath.row].title
        
        if let url = NSURL(string: self.videos[indexPath.row].thumbnail) {
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

    
    
}
