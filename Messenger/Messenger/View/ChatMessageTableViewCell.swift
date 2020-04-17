//
//  ChatMessageTableViewCell.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 17/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ChatMessageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recievedChatMessageLbl: UILabel!
    
    @IBOutlet weak var recievedChatMessageView: UIView!
    
    @IBOutlet weak var sentChatMessageLbl: UILabel!
    
    @IBOutlet weak var sentChatMessageView: UIView!
    
    var chatMessage: ChatMessage!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message: ChatMessage) {
        
        self.chatMessage = message
        
        if message.sender == currentUser {
            
            sentChatMessageView.isHidden = false
            
            sentChatMessageLbl.text = chatMessage.chatMessage
            
            recievedChatMessageLbl.text = ""
            
            recievedChatMessageLbl.isHidden = true
            
        } else {
            
            sentChatMessageView.isHidden = true
            
            sentChatMessageLbl.text = ""
            
            recievedChatMessageLbl.text = chatMessage.chatMessage
            
            recievedChatMessageLbl.isHidden = false
        }
    }

}
