//
//  LoginViewController.swift
//  avenir-design-app
//
//  Created by I AM PR Agency on 3/12/17.
//  Copyright © 2017 Avenir Design. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginPressed(_ sender: Any)
    {
        if emailField.text == "" {
            let alert: UIAlertController = UIAlertController(title: "Missing Email", message: "Make sure to fill out the email field!", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if pwdField.text == "" {
            let alert: UIAlertController = UIAlertController(title: "Missing Password", message: "Add a password!", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { action -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: pwdField.text!, completion: { (user, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                
                if user != nil
                {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                    self.present(vc, animated: true, completion: nil)
                }
                
                
            })
        }
        
        
        
        
    }

   

}
