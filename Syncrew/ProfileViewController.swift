//
//  ProfileViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 17/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var username:UILabel!
    
    
    var titles = ["My Rooms"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]

        
        self.navigationController?.navigationBar.backItem?.title = "Home"
        self.navigationController?.navigationBar.tintColor = .white

    
        self.tableview.backgroundColor = UIColor(hexString: Constants.themeColor2)
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)


        self.username.text = AccountManager.getInstance().account.name
        
    }
    

    
    
    /* Table View Functions */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ProfileCell
        
        cell.title.text = self.titles[indexPath.row]
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyRooms") as! ProfileRoomViewController
            self.show(vc, sender: nil)
            
            break
        default:
            break
        }
    }

}
