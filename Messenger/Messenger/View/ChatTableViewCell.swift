//
//  ChatTableViewCell.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 16/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileChat: UILabel!

    var chatDetail: ChatDetail!
    
    var userChatKey: DatabaseReference!
    
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(chatDetail: ChatDetail){
        
        self.chatDetail = chatDetail
        
        let profileData = Database.database().reference().child("users").child(chatDetail.profile)
        
        profileData.observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
           let username = data["username"]
            
            let userImage = data["userImg"]
            
            self.profileName.text = username as? String
            
            let reference = Storage.storage().reference(forURL: userImage as! String)
            
            reference.getData(maxSize: 1000000, completion: { (data, error) in
                
                if error != nil {
                    print("could not load image")
                } else {
                    
                    if let imageData = data {
                        
                        if let image = UIImage(data: imageData) {
                            
                            self.profileImage.image = image
                        }
                    }
                }
            })
        })
        
    }

}
