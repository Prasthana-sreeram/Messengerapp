//
//  SearchViewController.swift
//  Messenger
//
//  Created by SREERAM PURANAM on 22/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import Firebase

import SwiftKeychainWrapper

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchDetail = [ChatSearch]()
    
    var filteredData = [ChatSearch]()
    
    var isSearching = false
    
    var detail: ChatSearch!
    
    var recipient: String!
    
    var messageId: String!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
               
        tableView.dataSource = self
               
        searchBar.delegate = self

        searchBar.returnKeyType = UIReturnKeyType.done
        
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            
            self.searchDetail.removeAll()
            
            for data in snapshot {
                
                if let postDict = data.value as? Dictionary<String, AnyObject> {
                    
                    let key = data.key
                    
                    let post = ChatSearch(searchUserKey: key, postData: postDict)
                    
                    self.searchDetail.append(post)
                }
            }
        }
             self.tableView.reloadData()
    })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destionViewController = segue.destination as? ChatMessageViewController {
            
            destionViewController.profile = recipient
            
            destionViewController.chatMessageID = messageId
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isSearching {
                      
                      return filteredData.count
                      
                  }else {
                      
                      return searchDetail.count
                  }
        
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let searchData: ChatSearch!
        
        if isSearching {
            
            searchData = filteredData[indexPath.row]
            
        } else {
            
            searchData = searchDetail[indexPath.row]
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? SearchTableViewCell {
            
            
            
            cell.configCell(searchDetail: searchData)
            
            return cell
            
        } else {
            
            return SearchTableViewCell()
        }
        
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isSearching {
            
            recipient = filteredData[indexPath.row].searchUserKey
            
        } else {
            
            recipient = searchDetail[indexPath.row].searchUserKey
        }
        
        performSegue(withIdentifier: "Chat-Message", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            
            view.endEditing(true)
            
            tableView.reloadData()
            
        } else {
            
            isSearching = true
            
            filteredData = searchDetail.filter({ $0.searchUserName == searchBar.text! })
            
            tableView.reloadData()
        }
    }
    
    
    
    @IBAction func goBack(_ sender: AnyObject){
        
        dismiss(animated: true, completion: nil)
        
    }

 
}
