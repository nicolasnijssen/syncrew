//
//  RoomCreatorViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 10/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit
import Alamofire
import JAYSON

class RoomCreatorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField : UITextField!
    @IBOutlet var imageField : UITextField!
    @IBOutlet var typeControl : UISegmentedControl!

    

    var success = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameField.delegate = self
        imageField.delegate = self
        
        
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = UIColor(hexString: Constants.themeColor2)

    }
    
    
    @IBAction func postRoom(){
        

        let parameters: Parameters = ["roomTitle": self.nameField.text!, "":"","user_id":AccountManager.getInstance().account!.id]
        
        Alamofire.request("https://syncrew-auth0.herokuapp.com/api/room",method: HTTPMethod.post, parameters: parameters).responseJSON{ response in
            
            let respo = response.result.value
            
            print(respo!)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
}
