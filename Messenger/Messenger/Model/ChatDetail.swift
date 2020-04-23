//
//  ChatDetail.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 16/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper
 
class ChatDetail{
    
    private var _profile: String!
    
    private var _chatKey: String!
    
    private var _chatRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var profile: String{
       
        return _profile
    }
    
    var chatKey: String{
        
        return _chatKey
    }
    
    var chatRef: DatabaseReference{
        
        return _chatRef
    }
    
    init(profile: String) {
        
        _profile = profile
    }
    
    init(chatKey:String, chatData: Dictionary<String, AnyObject>) {
        
        _chatKey = chatKey
        
        if let profile = chatData["profile"] as? String{
            
            _profile = profile
        }
        
        _chatRef = Database.database().reference().child("profile").child(_chatKey)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
