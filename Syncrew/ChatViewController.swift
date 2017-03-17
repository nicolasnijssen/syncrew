//
//  ChatViewController.swift
//  Syncrew
//
//  Created by Nicolas Nijssen on 08/03/2017.
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import JAYSON
import Alamofire

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,NNStompClientDelegate,NNVideoSocketDelegate {
    
    
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var noMessages:UILabel!
    
    var messages:Array<Message> = Array<Message>()
    let stream = StreamViewController()
    var youtube:YTFViewController!
    let barHeight: CGFloat = 50
    var socket:NNStompClient!
    var urls: [URL] = []
    var room:Room!
    var user:Account!
    
    
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true

            return self.inputBar
        }
    }
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getPlaying()
        self.title = self.room.name
        
        self.user = AccountManager.getInstance().account
        
        
        self.inputAccessoryView?.sendSubview(toBack: self.view)

        //Socket init
        socket = NNStompClient()
        socket.delegate = self
        socket.openSocketWithURL(url: URL(string:"wss://syncrew-auth0.herokuapp.com/websocket")!, delegate: self, connectionHeaders: ["accept-version": "1.1,1.0", "heart-beat": "10000,10000"])
        
        
        
        //Layout changes
        self.tableview.backgroundColor = UIColor(hexString: "f0f5fd")
        self.view.backgroundColor = UIColor(hexString: "f0f5fd")
        
        tableview.separatorStyle = .none
        tableview.estimatedRowHeight = self.barHeight
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.contentInset.bottom = self.barHeight
        tableview.scrollIndicatorInsets.bottom = self.barHeight
        

        inputTextField.delegate = self
        inputTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, -5, 0)
        inputTextField.attributedPlaceholder = NSAttributedString(string: "Type message...",
                                                                  attributes: [NSForegroundColorAttributeName: UIColor(hexString:"767C84")])
        
        //Set video queue and admin rules
        self.stream.videos = room.videos
        self.stream.isAdmin = self.isAdmin()
        

        //retrieve all playback urls from videos and when finished show videoplayer
        self.retrieveUrls{
            
            //Show videoplayer in this view
            YTFPlayer.initYTF(self.urls, tableCellNibName: "VideoCell", delegate: self.stream, dataSource: self.stream)
            YTFPlayer.showYTFView(self)
        
            //retrieve responsible ViewController for video syncing
            self.youtube = YTFPlayer.getYTFViewController() as! YTFViewController
            
            self.youtube.videoDelegate = self
            self.youtube.input = self.inputBar
            
        }
        
        
        if !isAdmin() {
            
            self.youtube.hidePlayerControls()
        }
    }
    
    
    /* WEBSOCKET METHODS */
    
    func stompClientDidConnect(client: NNStompClient!) {
        
        print("CONNECTED")
        self.socket.subscribeToDestination(destination: "/topic/syncmessages", withHeader: ["id": "sub-0"])
        self.socket.subscribeToDestination(destination: "/topic/chatmessages", withHeader: ["id": "sub-0"])

    }
    
    func stompClientDidDisconnect(client: NNStompClient!) {
        
        
    }
    
    func stompClientWillDisconnect(client: NNStompClient!, withError error: NSError) {
        
    }
    
    func stompClient(client: NNStompClient!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, withHeader header: [String : String]?, withDestination destination: String) {
        
        print("Jayson body \(jsonBody)")
        print("Destination \(destination)")
        let jayson = try! JAYSON(any:jsonBody!)

        //check message destination
        if (destination == "/topic/chatmessages"){
            if jayson["id"].string! == String(room.id) {
                addMessageToTable(message: Message(username: jayson["extra"].string!, messageText: jayson["content"].string!))
            }
        }else if (destination == "/topic/syncmessages"){
            
        
            if jayson["id"].string! == String(room.id) {
                syncVideo(content: jayson["content"].string!, time:jayson["extra"].string!)
            }
        }
        
    }
    
    
    func serverDidSendReceipt(client: NNStompClient!, withReceiptId receiptId: String) {
        
    }
    
    func serverDidSendError(client: NNStompClient!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        
    }
    
    func serverDidSendPing() {
     
        print("PING RECEIVED")
    }
    
    
    
    
    //VIDEO METHODS
    func videoDidPlay(time: Double) {
        
        print("VIDEO PLAY")
        
        //use logged-in username
        let content = "{\"id\":\"\(room.id)\",\"content\":\"PLAYING\",\"extra\":\"\(time)\"}"
        
        socket.sendMessage(message: content, toDestination: "/app/sync", withHeaders: ["content-length":"\(content.characters.count)"], withReceipt: "")
    }
    
    func videoDidPause(time: Double) {
     
        print("VIDEO PAUSE")
        //use logged-in username
        let content = "{\"id\":\"\(room.id)\",\"content\":\"PAUSED\",\"extra\":\"\(time)\"}"
        
        socket.sendMessage(message: content, toDestination: "/app/sync", withHeaders: ["content-length":"\(content.characters.count)"], withReceipt: "")

    }
    
    func videoDidChangePlayTime(time: Double) {
        
        print("VIDEO CHANGE TIME")

    }
    
    func videoIsNormalscreen() {
        
        self.inputBar.isHidden = false

    }
    
    func videoIsFullscreen() {
        
        self.inputBar.isHidden = true
    }
    
    
    //Sync video from incoming messages
    func syncVideo(content:String, time:String){
        
        switch content {
        case "PAUSED":
            self.youtube.playerView.pause()
            break
        case "BUFFERING":
            self.youtube.playerView.pause()
            self.youtube.playerView.currentTime = Double(time)!
            break
        case "PLAYING":
            self.youtube.playerView.currentTime = Double(time)!
            self.youtube.playerView.play()
            break
        case "CHANGEVIDEO":
            let index = getIndex(url: time)
            self.youtube.playIndex(index)
            break
        default:
            break
        }
        
    }
    
    
    func getIndex(url:String) -> Int{
        
        for var i in (0..<room.videos.count){
            
            if room.videos[i].youtube == url.components(separatedBy: ";")[0] {
                
                return i
            }
            
            
        }
        
        
        return 0
        
    }
    //add playback urls to url queue
    func retrieveUrls(_ completed: @escaping DownloadComplete){
        
        for var i in (0..<room.videos.count){
            
        
            self.urls.append(URL(string:room.videos[i].playback)!)
            
            
        }
        
        
        
        completed()
    }
    
    
    func getPlaying(){
        
        let headers: HTTPHeaders = ["Authorization": AccountManager.getInstance().token]

        
        let url = "https://syncrew-auth0.herokuapp.com/api/rooms/\(self.room.id)"
        
        Alamofire.request(url,headers:headers)
            .responseJSON { response in
                
                
                if let json = response.result.value {
                    
                    let jayson = try! JAYSON(any:json)
                
                    self.youtube.playIndex(self.getIndex(url: jayson["playingVideo"].dictionary!["url"]!.string!))

                }
                
        }
        
    }
    
    //send new message when send button is pushed
    @IBAction func sendNewMessage(){
        
        let message = self.inputTextField.text!
        
        //use logged-in username
        let content = "{\"id\":\"\(self.room.id)\",\"content\":\"\(message)\",\"extra\":\"\(self.user.name)\"}"
        
        
        socket.sendMessage(message: content, toDestination: "/app/chat", withHeaders: ["content-length":"\(message.characters.count)"], withReceipt: "")
        
        self.inputTextField.text = ""
    }

    
    //add chat messages to tableview
    func addMessageToTable(message:Message){
    
        messages.append(message)
        animateTable()

    }
    
    //reload tableview content and animate new chat messages
    func animateTable(){
        
        
        if messages.count > 0 {
            
            self.noMessages.isHidden = true
        }
        tableview.reloadData()
        
        let cells = tableview.visibleCells
        
        //animate last message
        let cell: UITableViewCell = cells[cells.count - 1] as UITableViewCell
        cell.transform = CGAffineTransform(translationX:cell.bounds.size.width + 100, y: 0)
        
        let cell2: UITableViewCell = cells[cells.count - 1] as UITableViewCell
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            cell2.transform = CGAffineTransform(translationX: 0, y: 0);
        }, completion: nil)
        
        
        //scroll down to last row in tableview
        let numberOfSections = self.tableview.numberOfSections
        let numberOfRows = self.tableview.numberOfRows(inSection: numberOfSections-1)
        
        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
        self.tableview.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        
        
    }
    
    
    /* TableView methods */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let message = messages[indexPath.row]

        //check if sender last message is logged in user
        if message.username == self.user.name {
            
            let cell:SenderCell

            cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            
            cell.backgroundColor = .clear
            
            cell.message.text = message.messageText
            
            return cell
            
        }else {
            
            let cell:ReceiverCell

            cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell

            cell.backgroundColor = .clear

            cell.message.text = message.chatMessage
            
            
            return cell

        }
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.inputTextField.resignFirstResponder()
        return true
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    func isAdmin()->Bool{
        
        if (self.room.admin ==  self.user.id){
            
            return true
        }
        
        return false
    }
    
    
    
 
    

}
