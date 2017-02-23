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

    @IBOutlet weak var playerView: YTPlayerView!

    @IBOutlet weak var tableview: UITableView!
    
    
    public let stream = StreamViewController()

    var videoID: String!

    var room_id:String = ""
    
    var videos:Array<Video> = Array<Video>()
    var urls: [URL] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.title = "Chat"
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.isTranslucent = true
        

        
        self.retrieveVideos {
            
            print("LOADING")
            self.stream.videos = self.videos
            
            
            YTFPlayer.initYTF(self.urls, tableCellNibName: "VideoCell", delegate: self.stream, dataSource: self.stream)
            YTFPlayer.showYTFView(self)
            
        }

    }

 
    
    func retrieveVideos(_ completed: @escaping DownloadComplete){
        
        Alamofire.request("http://127.0.0.1:8000/api/videos/\(room_id)").responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any: json)
                
                for var i in (0..<jayson.array!.count){
                    
                    let video:Video = Video(title: jayson[i]["title"].string!, thumbnail: jayson[i]["thumbnail"].string!,youtube:jayson[i]["youtube"].string!,playback:jayson[i]["playback"].string!)
                    
                    print("Video \(video.title)")
                    self.videos.append(video)
                    self.urls.append(URL(string:video.playback)!)


                }
            }
            completed()

        }
        
    }
    
    /*
    
    func allPayback(completion: (_ result: String) -> Void){
        
        
        for index in 0 ..< videos.count {
            
            retrievePlayback(yt: videos[index].youtube)
        }
        
        completion("Finished")
        
    }
    
    func retrievePlayback(yt:String){
        
        Alamofire.request("https://helloacm.com/api/video/?cached&video=\(yt)").responseJSON { response in
            
            print(response.result.value!)
            
            if let json = response.result.value {
             
                let jayson = try! JAYSON(any: json)

                let url = jayson["url"].string!
                
                
            }
 
            
        }


    }
 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

 */
}






