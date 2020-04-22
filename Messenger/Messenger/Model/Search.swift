//
//  Search.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 22/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatSearch{
    
    private var _searchUserName: String!
    
    private var _searchUserImage: String!
    
    private var _searchUserKey: String!
    
    private var _searchUserRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var searchUserName: String{
        
        return _searchUserName
    }
    
    var searchUserImage: String{
        
        return _searchUserImage
    }
    
    var searchUserKey: String{
        
        return _searchUserKey
        
    }
    
    
    
    
    init(searchUserName: String, searchUserImage: String) {
        
        _searchUserName = searchUserName
        
        _searchUserImage = searchUserImage
    }
    
    init(searchUserKey: String, postData: Dictionary<String, AnyObject>) {
        
        _searchUserKey  = searchUserKey
        
        if let searchUserName = postData["UserName"] as? String{
            
            _searchUserName = searchUserName
        }
        
        if let searchUserImage = postData["searchUserImage"] as? String {
            
            _searchUserImage = searchUserImage
        }
        
        _searchUserRef = Database.database().reference().child("chatMessages").child(_searchUserKey)
    }
}
