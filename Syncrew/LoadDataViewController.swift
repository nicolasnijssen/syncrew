//
//  LoadDataViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 14/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit

class LoadDataViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.performSegue(withIdentifier: "loggedIn", sender: self)
    }
}
