//
//  SecondViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!

    var videoID: String!

    
    let videos = [
        
                Video.init(name: "iPhone 7 - The Missing Feature...", artist: "Unbox Therapy", url: URL(string: "http://r4---sn-p5qlsnel.googlevideo.com/videoplayback?ei=quqaWNG9DobH1gKEoZi4BQ&dur=237.424&lmt=1476174474559900&pl=24&ipbits=0&upn=d32g2G-ZB8U&expire=1486569226&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&mime=video%2Fmp4&key=yt6&itag=22&initcwndbps=4742500&id=o-AFMUgUjUViqCQHrsm5kbDGgEKOxHIJ-mv54d8DyPPrSf&source=youtube&mm=31&mn=sn-p5qlsnel&ms=au&mt=1486547607&ratebypass=yes&mv=m&ip=159.253.144.86&signature=B5CCBA1B311E754E4526AA0DA2B65462426D3817.11A780A9918707AE4186E35621C2229FF561D4B1&title=iPhone+7+-+The+Missing+Feature...")!),
                  Video.init(name: "iPhone 7 - Magnetic Charging Magic", artist: "Unbox Therapy", url: URL(string: "http://r3---sn-p5qlsnsk.googlevideo.com/videoplayback?id=o-AJ5DP6vCMiRIM-weCaW5hKWlET0y5AP6z_0l0nFppKHp&dur=319.924&mm=31&mn=sn-p5qlsnsk&pl=24&ms=au&mt=1486548079&mv=m&ip=159.253.144.86&mime=video%2Fmp4&signature=4A381DF8C3824B017835821F3A5110A5192AD780.B003294464D3CF74350127F206209E6B05D29F52&key=yt6&ei=juyaWL7OLoPD1gLUxrOADg&initcwndbps=4333750&source=youtube&lmt=1481460367196538&itag=22&ipbits=0&upn=OCZQKJdC8tA&expire=1486569710&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&ratebypass=yes&title=iPhone+7+-+Magnetic+Charging+Magic")!),
                  Video.init(name: "World's Loudest Bluetooth Speaker!", artist: "Unbox Therapy", url: URL(string: "http://r1---sn-p5qlsnle.googlevideo.com/videoplayback?dur=344.769&source=youtube&id=o-APGHWWNW4w2_g-FGImi0tpfI90Goup747zhRKda-NSVW&initcwndbps=4333750&lmt=1486362797722393&itag=22&mime=video%2Fmp4&expire=1486569751&signature=04C57BA366CF38D2F10E1A43FCDD74C001F8F6C5.0A8C2317FF415764241AEE93E61B4D2296F96315&ip=159.253.144.86&ratebypass=yes&ipbits=0&ms=au&mt=1486548079&pl=24&mv=m&ei=t-yaWK3pD9e-1gKGqLrwBA&mm=31&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&mn=sn-p5qlsnle&upn=hEHPh6FX5-c&key=yt6&title=World%27s+Loudest+Bluetooth+Speaker%21")!)]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urls: [URL] = []
        for video in videos {
            urls.append(video.url)
        }

        YTFPlayer.initYTF(urls, tableCellNibName: "VideoCell", delegate: self, dataSource: self)
        YTFPlayer.showYTFView(self)

        
        //playerView.load(withVideoId: "5FPFCEIxvJM")

        //
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        return cell
    }
}

extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! VideoCell
        cell.labelArtist.text = videos[indexPath.row].artist
        cell.labelTitle.text = videos[indexPath.row].name
        if (indexPath.row % 2 == 0) {
            cell.imageThumbnail.image = UIImage(named: "bigBunny")
        } else {
            cell.imageThumbnail.image = UIImage(named: "legoToy")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        YTFPlayer.playIndex(indexPath.row)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}



