//  Syncrew
//
//  Created by Nicolas Nijssen
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertBottomConstraint: NSLayoutConstraint!
    
    
    

    var items = [Conversation]()
    
    var selectedUser: User?
    
    //MARK: Methods
    func customization()  {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
      
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]
       
        // notification setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showEmailAlert), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setImage(UIImage(named: "plus"), for: UIControlState.normal)
        
        rightBtn.addTarget(self, action: #selector(self.showContacts), for:  UIControlEvents.touchUpInside)
        
        let item = UIBarButtonItem(customView: rightBtn)
        
        self.navigationItem.rightBarButtonItem = item
      
        //left bar button image fetching
        
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftBtn.setImage(UIImage(named: "profile pic"), for: UIControlState.normal)
        
        leftBtn.addTarget(self, action: #selector(self.showProfile), for:  UIControlEvents.touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
     
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if let id = FIRAuth.auth()?.currentUser?.uid {
            
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                let image = user.profilePic
                
                let contentSize = CGSize(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
                
                let _  = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
                
                let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
                
                path.lineWidth = 2
                
                UIColor.black.setStroke()
                
                path.stroke()
               
                //let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
               
                UIGraphicsEndImageContext()
                
                DispatchQueue.main.async {
                    //weakSelf?.leftButton.image = finalImage
                   // weakSelf = nil
                }
            })
        }
    }
    
    //Downloads conversations
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp } //recent conversations first
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        //self.playSound()
                        break
                    }
                }
            }
        }
    }
    
    //Shows profile extra view
    func showProfile() {
        let info = ["viewType" : ShowExtraView.profile]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
        self.inputView?.isHidden = true
    }
    
    //Shows contacts extra view
    func showContacts() {
        let info = ["viewType" : ShowExtraView.contacts]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
    }
    
    //Show EmailVerification on the bottom
    func showEmailAlert() {
        User.checkUserVerification {[weak weakSelf = self] (status) in
            status == true ? (weakSelf?.alertBottomConstraint.constant = -40) : (weakSelf?.alertBottomConstraint.constant = 0)
            UIView.animate(withDuration: 0.3) {
                weakSelf?.view.layoutIfNeeded()
                weakSelf = nil
            }
        }
    }
    
    //Shows Chat viewcontroller with given user
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    /*
    func playSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "newMessage", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }

    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }

    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsTBCell
            cell.clearCellData()
            cell.profilePic.image = self.items[indexPath.row].user.profilePic
            cell.nameLabel.text = self.items[indexPath.row].user.name
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                let message = self.items[indexPath.row].lastMessage.content as! String
                cell.messageLabel.text = message
            case .location:
                cell.messageLabel.text = "Location"
            default:
                cell.messageLabel.text = "Media"
            }
            let messageDate = Date(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
                cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
                cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
                cell.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
                cell.messageLabel.textColor = GlobalVariables.blue
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
       
    //MARK: ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showEmailAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
}





