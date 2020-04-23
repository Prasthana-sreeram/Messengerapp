//
//  ChatViewController.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 16/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var chatDetail = [ChatDetail]()
    
    var detail: ChatDetail!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var profile: String!
    
    var chatID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        tableView.delegate = self
        
        tableView.dataSource = self
        
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: {
            (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                self.chatDetail.removeAll()
                
                for data in snapshot{
                    
                    if let chatDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let info = ChatDetail(chatKey: key, chatData: chatDict)
                        
                        self .chatDetail.append(info)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatDetail.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let chatDetails = chatDetail[indexPath.row]
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? ChatTableViewCell{
        
        cell.configureCell(chatDetail: chatDetails)
        
        return cell
        
    }else{
      
     return ChatTableViewCell()
        
    }
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        profile = chatDetail[indexPath.row].profile
        chatID = chatDetail[indexPath.row].chatRef.key
        
        performSegue(withIdentifier: "Chat-Message", sender: nil)
    }
        
        override func prepare (for segue: UIStoryboardSegue, sender: Any?){
            if let destinationViewcontroller = segue.destination as? ChatMessageViewController{
                
                destinationViewcontroller.profile = profile
                
                destinationViewcontroller.chatMessageID  = chatID
                
            }
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        
        dismiss(animated: true, completion: nil)
    }
            
}
    

