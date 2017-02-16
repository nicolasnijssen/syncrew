//
//  ViewController.swift
//  CellwithScroll
//
//  Created by Mauro Axel on 9/1/17.
//  Copyright © 2017 Mauro Axel. All rights reserved.
//

import UIKit
import Alamofire
import JAYSON

class HomeViewController: UIViewController, UITableViewDataSource {
   
    @IBOutlet weak var table: UITableView!

    var headers = ["Public", "Private"]
    
    let api = APICommunicator.instance

    var rooms:Array<Room> = Array<Room>()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        table.backgroundColor = .clear
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        

        DispatchQueue.main.async {
            print("start")
            self.api.retrieveRooms()
            self.table.reloadData()
            
            print("reload")
            
    
        }

    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func retrieveRooms(){
        
        Alamofire.request("http://127.0.0.1:8000/api/rooms").responseJSON { response in
            
            if let json = response.result.value {
                
                let jayson = try! JAYSON(any:json)
                
                for var i in (0..<jayson.array!.count){
                    
                    let room:Room = Room(id: jayson[i]["id"].int!,name: jayson[i]["name"].string!, thumbnail: jayson[i]["thumbnail"].string!, type: jayson[i]["room_type"].string!)
                    
                    
                    self.rooms.append(room)
                    print("+1 Room count: \(self.rooms.count)")
                    print("naam \(room.name)")
                }
                
            }
            
        }
    }

    
    
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor.clear
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = headers[section]
        headerView.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant:6.5).isActive = true
        label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
 
        return headerView
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("AANTAL ROOMS: \(self.api.rooms.count)")
        if indexPath.section == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: "public") as! RowCategory
            cell.type = "public"
            
            cell.backgroundColor = .red
            cell.selectionStyle = UITableViewCellSelectionStyle.none;

        
            return cell

        
        } else if indexPath.section == 1{
            let cell = table.dequeueReusableCell(withIdentifier: "private") as! RowCategory
            cell.type = "private"
            cell.backgroundColor = .black
            cell.selectionStyle = UITableViewCellSelectionStyle.none;

            
            return cell

        }
        
        let cell =  UITableViewCell()
        cell.backgroundColor = .blue
        cell.selectionStyle = UITableViewCellSelectionStyle.none;

        
        return cell
    }
    

    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    

}

