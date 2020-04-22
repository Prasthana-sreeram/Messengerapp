//
//  SignUpViewController.swift
//  Messenger
//
//  Created by admin prasthana on 14/04/20.
//  Copyright © 2020 admin prasthana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var userImagePicker: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var userUid: String!
    
    var username: String!
    
    var emailTextField: String!
    
    var passwordTextField: String!
    
    var imagePicker: UIImagePickerController!
    
    var imageSeclected = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        if let _ = KeychainWrapper.standard.string(forKey: "Uid"){

            performSegue(withIdentifier: "Messages", sender: nil)
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]){



        if let image =  info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage{

                userImagePicker.image = image
                imageSeclected = true

            }else{

                print("image was not selected")
            }

            imagePicker.dismiss(animated: true, completion: nil)

        }

    }
//    func setupmainImageview(){
//           userImagePicker.layer.cornerRadius = 40
//           userImagePicker.clipsToBounds = true
//           userImagePicker.isUserInteractionEnabled = true
//           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
//           userImagePicker.addGestureRecognizer(tapGesture)
//       }
//       @objc func presentPicker() {
//           let picker = UIImagePickerController()
//           picker.sourceType = .photoLibrary
//           picker.allowsEditing = true
//           picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
//           self.present(picker,animated: true,completion: nil)
//       }

    
    func setUser(image: String) -> Void{
        
        let userData = [
            "username": username!,
            "userImage": image
        ]
        
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        let location = Database.database().reference().child("users").child(userUid)
        
        location.setValue(userData)
        
        dismiss(animated: true, completion: nil)
        
       
    }
    func uploadeImg(){
        
        if usernameTextField.text == nil{
            
            signUpButton.isEnabled = false
            
        }else{
            
            username = usernameTextField.text
            
            signUpButton.isEnabled = true
            
        }
        
        guard let image = userImagePicker.image, imageSeclected == true
            else{
                print("select your image")
                return
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.2){
            
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            Storage.storage().reference().child(imageUid).putData(imageData, metadata: metadata){
                (metadata, error) in
                
                if  error != nil{
                    print("Did not upload Image")
                    
                }else{
                    
                    print("uploaded")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let imageurl = downloadURL{
                        self.setUser(image: imageurl)
                        
                    }
                }
        
            }
        }
            
    }
        
   
    @IBAction func createAccount (_ sender: AnyObject){
        
        Auth.auth().createUser(withEmail: emailTextField, password: passwordTextField, completion: {
            (user, error) in
            
            if error != nil{
                
                print("Can't create user")
                
            }else{
                
                if let user = user{
                    self.userUid = user.user.uid
                }
            }
            
            self.uploadeImg()
        })
            
    }
    
    

    @IBAction func selectedImgPicker(_ sender: AnyObject){
        
        present(imagePicker, animated: true,completion: nil)
    }
    
    @IBAction func cancel (_ sender: AnyObject){
        
        dismiss(animated: true, completion: nil)
    }

   
}
