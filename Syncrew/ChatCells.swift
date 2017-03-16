import Foundation
import UIKit
 

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var messageBackground: UIImageView!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.messageBackground.backgroundColor = UIColor(hexString: "d3dfec")
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 7
        self.messageBackground.clipsToBounds = true
        
        let bgc:UIColor = self.messageBackground.backgroundColor!
        
        if(bgc.isLight()){
            
            self.message.textColor = .black
        }else{
            
            self.message.textColor = .white
        }
    }
}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    @IBOutlet weak var sender: UILabel!

    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.messageBackground.backgroundColor = UIColor(hexString: "4775e1")
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 9
        self.messageBackground.clipsToBounds = true
        
        let bgc:UIColor = self.messageBackground.backgroundColor!
        
        if(bgc.isLight()){
            
            self.message.textColor = .black
        }else{
            
            self.message.textColor = .white
        }
    }
}



