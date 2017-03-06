//
//  Account.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 06/03/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit

class Account: NSObject {
    
    var id:Int
    var name:String
    var email:String
    
    
    init(id:Int, name:String, email:String) {
    
        self.id = id
        self.name = name
        self.email = email
        
    }
}
