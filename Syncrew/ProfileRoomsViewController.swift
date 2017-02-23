//
//  ProfileRoomsViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 17/02/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit

class ProfileRoomViewController: UITableViewController {
    
    
    var currentRooms = ["Fail army room", "4th room"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]
        
        
        
        self.tableView.backgroundColor = UIColor(hexString: Constants.themeColor2)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    
    /* Table View Functions */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return currentRooms.count
        }else {
            return 1
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ProfileCell
        
        
        if indexPath.section == 0 {
            
            cell.title.text = self.currentRooms[indexPath.row]

        } else if (indexPath.section == 1) {
            
            cell.title.textAlignment = .center
            cell.title.text = "Create new room"
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor(hexString: Constants.themeColor2)
        
        return headerView
        
        
    }
    


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 1){
            
            return 104.0
        }
        
        return 1.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateRoom") as! RoomCreatorViewController
            self.show(vc, sender: nil)
        }
    }
    
    
    
}
