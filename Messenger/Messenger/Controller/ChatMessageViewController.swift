//
//  ChatMessageViewController.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 16/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    

    var chatMessageID: String!
    
    var messages = [ChatMessage]()
    
    var message: ChatMessage!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var profile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 300
        
        if chatMessageID != "" && chatMessageID != nil{
            
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            
            self.moveToBottom()
    }
    }
        
    @objc func keyboardWillShow(notify: NSNotification) {
               
               if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                   
                   if self.view.frame.origin.y == 0 {
                       
                       self.view.frame.origin.y -= keyboardSize.height
                   }
               }
           }
           
    @objc func keyboardWillHide(notify: NSNotification) {
               
               if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                   
                   if self.view.frame.origin.y != 0 {
                       
                       self.view.frame.origin.y += keyboardSize.height
                   }
               }
           }
    
    @objc override func dismissKeyboard() {
        
        view.endEditing(true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let message = messages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessagesCell") as? ChatMessageTableViewCell{
            
            cell.configCell(message: message)
            
            return cell
            
        } else{
            
            return ChatMessageTableViewCell()
        }
       }

    func loadData(){
        
        Database.database().reference().child("Chatmessages").child(chatMessageID).observe(.value, with: {(snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                self.messages.removeAll()
                
                for data in snapshot{
                    
                    if let postDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let post = ChatMessage(chatMessageKey: key, postData: postDict)
                        
                        self.messages.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func moveToBottom() {
        
        if messages.count > 0  {
            
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @IBAction func sendPressed (_ sender: AnyObject){
        
        dismissKeyboard()
        
        if (messageTextField.text != nil && messageTextField.text != "") {
            
            if chatMessageID == nil {
                
                let post: Dictionary<String, AnyObject> = [
                    "message": messageTextField.text as AnyObject,
                    "sender": profile as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastmessage": messageTextField.text as AnyObject,
                    "recipient": profile as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
                    "lastmessage": messageTextField.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                
                chatMessageID = Database.database().reference().child("messages").childByAutoId().key
                
                let firebaseMessage = Database.database().reference().child("messages").child(chatMessageID).childByAutoId()
                
                firebaseMessage.setValue(post)
                
                let profileMessage = Database.database().reference().child("users").child(profile).child("messages").child(chatMessageID)
                
                profileMessage.setValue(recipientMessage)
                
                let userMessage = Database.database().reference().child("users").child(currentUser!).child("messages").child(chatMessageID)
                
                userMessage.setValue(message)
                
                loadData()
            } else if chatMessageID != "" {
                
                let post: Dictionary<String, AnyObject> = [
                    "message": messageTextField.text as AnyObject,
                    "sender": profile as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastmessage": messageTextField.text as AnyObject,
                    "recipient": profile as AnyObject
                ]
                
                let profileMessage: Dictionary<String, AnyObject> = [
                    "lastmessage": messageTextField.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                
                let firebaseMessage = Database.database().reference().child("messages").child(chatMessageID).childByAutoId()
                
                firebaseMessage.setValue(post)
                
                let recipentMessage = Database.database().reference().child("users").child(profile).child("messages").child(chatMessageID)
                
                recipentMessage.setValue(profileMessage)
                
                let userMessage = Database.database().reference().child("users").child(currentUser!).child("messages").child(chatMessageID)
                
                userMessage.setValue(message)
                
                loadData()
            }
            
            messageTextField.text = ""
        }
        
        moveToBottom()
    }
    
    @IBAction func backPressed (_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
   

}

