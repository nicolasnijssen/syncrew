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
    var isAdmin:Bool = false
    
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
        
    
        cell.labelTitle.frame = CGRect(x: 8, y: 0, width: 100, height: 42.0)
        cell.labelTitle.text = self.videos[indexPath.row].title
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isAdmin {
            
            YTFPlayer.playIndex(indexPath.row)
            videos.remove(at: indexPath.row)
            tableView.reloadData()
            

        }
    }

    
    
}
