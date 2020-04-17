

//
//  Chat-Message.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 17/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatMessage{
    
    private var _chatMessage: String!
    
    private var _sender: String!
    
    private var _chatMessageKey: String!
    
    private var _chatMessageRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var chatMessage: String{
        
        return _chatMessage
    }
    
    var sender: String{
        
        return _sender
    }
    
    var chatMessageKey: String{
        
        return _chatMessageKey
    }
    
    init(chatMessage: String, sender: String) {
        
        _chatMessage = chatMessage
        
        _sender = sender
    }
    
    init(chatMessageKey: String, postData: Dictionary<String, AnyObject>) {
        
        _chatMessageKey = chatMessageKey
        
        if let chatMessage = postData["chatMessage"] as? String{
            
            _chatMessage = chatMessage
        }
        
        if let sender = postData["sender"] as? String {
            
            _sender = sender
        }
        
        _chatMessageRef = Database.database().reference().child("chatMessages").child(_chatMessageKey)
    }
}
