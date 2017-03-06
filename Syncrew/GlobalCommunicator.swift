//
//  GlobalCommunicator.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 06/03/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import JAYSON

class GlobalCommunicator: NSObject {
    
    
    var account:Account!
    
    static var sharedInstance:GlobalCommunicator?
    
    
    
    static func getInstance() -> GlobalCommunicator {
        
        if (sharedInstance == nil){
            
            sharedInstance = GlobalCommunicator()
        }
        
        return sharedInstance!
    }
    
    
    func getAccountInfo(){
        
        Alamofire.request("http://127.0.0.1:8000/api/users/1").responseJSON { response in
            
            if let json = response.result.value {
                
                
                let jayson = try! JAYSON(any:json)
                
                let account:Account = Account(id: jayson["id"].int!, name: jayson["name"].string!, email: jayson["email"].string!)
                    
                self.account = account
                    
                
                
            }
            
        }

    }
    
}
