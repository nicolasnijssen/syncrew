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

class AccountManager: NSObject {
    
    
    var account:Account!
    var token:String!
    
    static var sharedInstance:AccountManager?
    
    
    
    static func getInstance() -> AccountManager {
        
        if (sharedInstance == nil){
            
            sharedInstance = AccountManager()
        }
        
        return sharedInstance!
    }
    
    
    public func getAccountInfo(username:String){
        
        
        let headers: HTTPHeaders = ["Authorization": AccountManager.getInstance().token]
        
        let url = "https://syncrew-auth0.herokuapp.com/api/users/\(username)"
        
        Alamofire.request(url,headers: headers).responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any:json)
                
                let account:Account = Account(id: jayson["userId"].int!, name: jayson["username"].string!, email: jayson["email"].string!)
                
                print("Account id: \(account.id)")
                self.account = account
                
            }
            
        }

    }
    
}
