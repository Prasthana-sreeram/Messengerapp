//
//  SearchTableViewCell.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 22/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var searchImage: UIImageView!
    
    @IBOutlet weak var searchNameLabel: UILabel!
    
    var searchDetail: ChatSearch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     func configCell(searchDetail: ChatSearch) {
           
           self.searchDetail = searchDetail
           
        searchNameLabel.text = searchDetail.searchUserName
           
        let Reference = Storage.storage().reference(forURL: searchDetail.searchUserImage)
           
           Reference.data(withMaxSize: 1000000, completion: { (data, error) in
               
               if error != nil {
                   
                   print(" we couldnt upload the img")
                   
               } else {
                   
                   if let searchUserImage = data {
                       
                       if let image = UIImage(data: searchUserImage) {
                           
                           self.searchImage.image = image
                       }
                   }
               }
               
           })
       }

}
