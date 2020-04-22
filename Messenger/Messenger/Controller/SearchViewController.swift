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

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func goBack(_ sender: AnyObject){
        
        dismiss(animated: true, completion: nil)
        
    }

 
}
