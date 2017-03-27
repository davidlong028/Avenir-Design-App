//
//  SignupViewController.swift
//  avenir-design-app
//
//  Created by I AM PR Agency on 3/9/17.
//  Copyright © 2017 Avenir Design. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var conPwdField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let storage = FIRStorage.storage().reference(forURL: "gs://avenir-design.appspot.com")
        
        ref = FIRDatabase.database().reference()
        userStorage = storage.child("users")
    }

    @IBAction func selectImagePressed(_ sender: Any)
    {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = image
            self.imageView.layer.cornerRadius = self.imageView.frame.width/2.0
            self.imageView.clipsToBounds = true
            self.imageView.layer.borderWidth = 1.0
            self.imageView.layer.borderColor = UIColor.white.cgColor
            signUpButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func nextPressed(_ sender: Any)
    {
        guard nameField.text != "", usernameField.text != "", passwordField.text != "", conPwdField.text != ""
            else {
                let alert: UIAlertController = UIAlertController(title: "Missing Some Info", message: "Make sure to fill out all of the fields!", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        if passwordField.text == conPwdField.text
        {
            FIRAuth.auth()?.createUser(withEmail: usernameField.text!, password: passwordField.text!, completion:{(user, error)
            in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let user = user
                {
                    
                    let changeRequest = FIRAuth.auth()?.currentUser!.profileChangeRequest()
                    changeRequest?.displayName = self.nameField.text!
                    changeRequest?.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                    }
                        imageRef.downloadURL(completion: {(url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                            }
                            
                            if let url = url {
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name" : self.nameField.text!,
                                                                "urlToImage" : url.absoluteString]
                                
                               self.ref.child("user").child(user.uid).setValue(userInfo)
                                    
                                DispatchQueue.main.async(execute: {
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                                    self.present(vc, animated: true, completion: nil)
                                })
                            }
                        })
                })
                    uploadTask.resume()
                
            }
        })
            
        }
        else
        {
            let alert: UIAlertController = UIAlertController(title: "Passwords Don't Match", message: "Make sure your passwords match!", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            print("Passwords do not match!")
        }
    }
   
}
