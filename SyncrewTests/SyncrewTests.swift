//
//  SyncrewTests.swift
//  SyncrewTests
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import XCTest
import Alamofire
import JAYSON

@testable import Syncrew

class SyncrewTests: XCTestCase {
    
    override func setUp() {
    
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiRequest(){
        
        let expected_title = "I've Never Seen Anything Like It..."
        
        Alamofire.request("http://127.0.0.1:8000/api/videos/\(1)").responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any: json)
                
                
                XCTAssertNotNil(json)
                
                XCTAssertEqual(expected_title, jayson[0]["title"].string!)
                
            }
        }

    }
    
    func addVideo(){
        
        let video = Video(title: "test video", thumbnail: "test", youtube: "test", playback: "")
        
        XCTAssertEqual(video.title, "test video")
    }
    
    func testYoutubePlayer(){
        
        
        let video = VideoViewController()
        
        let stream = video.stream
        
        stream.viewDidLoad()
        
        XCTAssertNotNil(stream.videos)
        
    }
    
    
    func testPostRoom(){
        
        let name = "TestRoom"
        let parameters: Parameters = ["name": name, "thumbnail":"htttp://iets","room_type":"PUBLIC"]
        
        // All three of these calls are equivalent
        Alamofire.request("http://127.0.0.1:8000/api/rooms/add",method: HTTPMethod.post, parameters: parameters).responseJSON{
            
            response in
            
            if let json  = response.result.value {
                
                let jayson = try! JAYSON(any: json)

                XCTAssertEqual(name, jayson[0]["name"].string!)

            }
            

        }
        
    }
    
}
