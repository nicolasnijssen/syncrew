//
//  Extension.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 02/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit


// Download image from URL to UIImage
extension UIImage {
    class  func contentOfURL(link: String) -> UIImage {
        let url = URL.init(string: link)!
        var image = UIImage()
        do{
            let data = try Data.init(contentsOf: url)
            image = UIImage.init(data: data)!
        } catch _ {
            print("error downloading images")
        }
        return image
    }
}


enum RoomType{
    
    case Public
    case Private
}

