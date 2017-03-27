//
//  UploadViewController.swift
//  avenir-design-app
//
//  Created by I AM PR Agency on 3/18/17.
//  Copyright © 2017 Avenir Design. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //variables and outlets
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var postBtn: UIBarButtonItem!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var projectInfoTextField: UITextField!
    @IBOutlet weak var daysCount: UILabel!
    var picker = UIImagePickerController()
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var artBtn: UIButton!
    @IBOutlet weak var graphicBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    var codeSelect = false
    var artSelect = false
    var graphicSelect = false
    var webSelect = false
    var projectType = ""
 
    //timeframe stepper
    @IBAction func stepper(_ sender: UIStepper) {
        
        daysCount.text = String(sender.value)
        
           }
  
    //view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

    }
    
   
    //select type
    @IBAction func codePressed(_ sender: UIButton) {
        codeSelect = true
        artSelect = false
        graphicSelect = false
        webSelect = false
        typeLabel.text = "Programming"
    }
    @IBAction func artPressed(_ sender: UIButton) {
        codeSelect = false
        artSelect = true
        graphicSelect = false
        webSelect = false
        typeLabel.text = "Artwork"
    }
    @IBAction func graphicPressed(_ sender: UIButton) {
        codeSelect = false
        artSelect = false
        graphicSelect = true
        webSelect = false
        typeLabel.text = "Graphic Design"
    }
    @IBAction func webPressed(_ sender: UIButton) {
        codeSelect = false
        artSelect = false
        graphicSelect = false
        webSelect = true
        typeLabel.text = "Web Design"
    }
    
    func determineTypeOfProject() {
        if codeSelect == true {
            codeBtn.setImage(#imageLiteral(resourceName: "Code Filled-100 checked.png"), for: UIControlState.normal)
            projectType = "Code"
        } else {
            codeBtn.setImage(#imageLiteral(resourceName: "Code Filled-100.png"), for: UIControlState.normal)
        }
        if artSelect == true {
            artBtn.setImage(#imageLiteral(resourceName: "Da Vinci Filled-100 checked.png"), for: UIControlState.normal)
            projectType = "Artwork"
        } else {
            artBtn.setImage(#imageLiteral(resourceName: "Da Vinci Filled-100.png"), for: UIControlState.normal)
        }
        if graphicSelect == true {
            graphicBtn.setImage(#imageLiteral(resourceName: "PS Filled-100checked.png"), for: UIControlState.normal)
            projectType = "Graphic Design"
        } else {
            graphicBtn.setImage(#imageLiteral(resourceName: "PS Filled-100.png"), for: UIControlState.normal)
        }
        if webSelect == true {
            webBtn.setImage(#imageLiteral(resourceName: "Web Design Filled-100 checked.png"), for: UIControlState.normal)
            projectType = "Graphic Design"
        } else {
            webBtn.setImage(#imageLiteral(resourceName: "Web Design Filled-100.png"), for: UIControlState.normal)
                
            }
        
        }

    
    
    //select reference image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.previewImage.image = image
            selectBtn.isHidden = true
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //launches image picker when 'select reference image' is placed
    @IBAction func selectPressed(_ sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: { _ in })
    }
    
    
    
    
  
    //submit new project info to firebase under new post id, but with user ID in the project information
    @IBAction func postPressed(_ sender: Any) {
        //alert controllers to make sure all values are filled in
        determineTypeOfProject()
       
        if projectTitle!.text == "" {
            let alert: UIAlertController = UIAlertController(title: "Missing Title", message: "Give us a short description of your project", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        } else if previewImage.image == nil {
            let alert: UIAlertController = UIAlertController(title: "Missing Reference Image", message: "Give us an image so we understand what you're looking for in this project", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        } else if projectInfoTextField!.text == "" {
            let alert: UIAlertController = UIAlertController(title: "Missing Project Info", message: "Give us a links or logins for your project", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if projectType == "" {
            let alert: UIAlertController = UIAlertController(title: "Missing Project Type", message: "Pick an icon and tell us which type of project this is", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            //Continue to upload task
            
            let uid = FIRAuth.auth()!.currentUser!.uid
            let ref = FIRDatabase.database().reference()
            let storage = FIRStorage.storage().reference(forURL: "gs://avenir-design.appspot.com/")
            
            let key = ref.child("posts").childByAutoId().key
            let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
            
            
            let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
            let uploadTask = imageRef.put(data!, metadata: nil) {(metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                imageRef.downloadURL(completion: {(url, error) in
                    if let url = url {
                        let feed = ["userID" : uid,
                                    "pathToImage" : url.absoluteString,
                                    "title" : self.projectTitle.text!,
                                    "projectDescription" : self.projectInfoTextField.text!,
                                    "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                    "timeFrame" : self.daysCount.text!,
                                    "projectType" : self.projectType,
                                    "postID" : key] as [String : Any]
                        
                        let postFeed = ["\(key)" : feed]
                        
                        ref.child("posts").updateChildValues(postFeed)
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                })
            }
            let alert: UIAlertController = UIAlertController(title: "Success!", message: "Thanks for submitting a project! Check your dashboard for updates!", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            uploadTask.resume()
            
        }
        
        
        
        }
        
        
        

    }

