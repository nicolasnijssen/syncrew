//
//  ViewController.swift
//  CellwithScroll
//
//  Created by Mauro Axel on 9/1/17.
//  Copyright © 2017 Mauro Axel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    var headers = ["Public", "Private"]

    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        table.backgroundColor = .clear
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if indexPath.section == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: "public") as! RowCategory
            cell.type = "public"
            
            cell.backgroundColor = .clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none;

        
            return cell

        
        } else if indexPath.section == 1{
            let cell = table.dequeueReusableCell(withIdentifier: "private") as! RowCategory
            cell.type = "private"
            cell.backgroundColor = .clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none;

            
            return cell

        }
        
        let cell =  UITableViewCell()
        
        cell.backgroundColor = .clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none;

        
        return cell
    }
    

    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    

}

