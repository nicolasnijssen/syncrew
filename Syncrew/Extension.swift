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

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 2
    let numberOfItemsPerRow = 5
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 50
        let saturation = CGFloat(arc4random() % 100) / 50
        let brightness = CGFloat(arc4random() % 50) / 20
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    class func randomBackColor() -> UIColor {
        
        
        var colors = ["532bdc","F35D5C","90FF9E","F7D6A0","8BF4F0","A7FA67"]
        
       
        
        return UIColor(hexString: colors[Int(arc4random() % 6)])
    }
    
    func isLight() -> Bool
    {
        let components = self.cgColor.components!
        let c0 = components[0] * 299
        let c1 = components[1] * 587
        let c2 = components[2] * 114
        
        let brightness = (c0 + c1 + c2) / 1000
        
        if brightness < 0.5
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}





typealias DownloadComplete = () -> ()
typealias LoadComplete = () -> ()
typealias SocketComplete = () -> ()


enum RoomType{
    
    case Public
    case Private
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



