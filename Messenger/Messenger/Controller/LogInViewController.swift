//
//  LogInViewController.swift
//  Messenger
//
//  Created by admin prasthana on 14/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SignIn (_ sender: AnyObject){
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                
                if error == nil{
                    self.userUid = user?.user.uid
                    KeychainWrapper.standard.set(self.userUid, forKey: "Uid")
                    
                    self.performSegue(withIdentifier: "Messages", sender: nil)
                    
                }else{
                    self.performSegue(withIdentifier: "SignUp", sender: nil)
                }
                
            })
        }
        
    }

}
