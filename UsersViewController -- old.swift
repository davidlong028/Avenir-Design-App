//
//  UsersViewController.swift
//  avenir-design-app
//
//  Created by I AM PR Agency on 3/12/17.
//  Copyright © 2017 Avenir Design. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    var user = [User]()
    
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        let ref = FIRDatabase.database().reference()
        var dataSource: FUITableViewDataSource

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            self.dataSource = self.tableview.bind(to: self.ref) { tableview, indexPath, snapshot in
                let cell = tableview.dequeueReusableCell(withIdentifier: "USERCell", for: indexPath)
                cell.nameLabel.text = self.user[indexPath.row].fullName
                cell.userID = self.user[indexPath.row].userID
                cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
                return cell
            }

            
            
        }

        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count ?? 0
    }
    
    

  
    
    
    
    
    
    
    
    
    @IBAction func composePressed(_ sender: Any) {
    }
  
    @IBAction func menuPressed(_ sender: Any) {
    }

}













extension UIImageView {
    func downloadImage(from imgURL: String!){
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
                
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
