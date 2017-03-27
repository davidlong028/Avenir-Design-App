//
//  UserViewController.swift
//  avenir-design-app
//
//  Created by I AM PR Agency on 3/17/17.
//  Copyright © 2017 Avenir Design. All rights reserved.
//

import UIKit
import Firebase


class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    var feed = [PostFeed]()
    
    //let user = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        
        //loadProfile()
        setupProfile()
        fetchFeed()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.reloadData()
        
     
        
        //loadProfileData()
    }
    
    func setupProfile(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            //logout()
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            databaseRef.child("user").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    print(dict)
                    self.userName.text = dict["full name"] as? String
                    if let profileImage = dict["urlToImage"] as? String {
                        let url = URL(string: profileImage)
                        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                self.userImage?.image = UIImage(data: data!)
                                self.userImage.layer.cornerRadius = self.userImage.frame.width/2.0
                                self.userImage.clipsToBounds = true
                                self.userImage.layer.borderWidth = 1.0
                                self.userImage.layer.borderColor = UIColor.white.cgColor
                            }
                        
                        }).resume()
                    }
                }
            
            })
        }
    }
    
    func fetchFeed() {
        let ref = FIRDatabase.database().reference()
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict2 = snapshot.value as? [String : AnyObject] {
                print(dict2)
                if let postIdentify = dict2["userID"] as? String {
                    if postIdentify == FIRAuth.auth()?.currentUser?.uid {
                        let feeds = PostFeed()
                        if let author = dict2["author"] as? String, let projectDescription = dict2["projectDescription"] as? String, let pathToImage = dict2["pathToImage"] as? UIImage, let postID = dict2["postID"] as? String, let title = dict2["title"] as? String {
                            
                            feeds.author = author
                            feeds.pathToImage = pathToImage
                            feeds.title = title
                            feeds.projectDescription = projectDescription
                            feeds.postID = postID
                            self.feed.append(feeds)
                            
                            
                        }
                        
                    }
                    self.tableview.reloadData()
                }
                
                
                

            }
            
        })
        ref.removeAllObservers()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.feed.count)
        return self.feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: FeedCell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        cell.postImage.image = self.feed[indexPath.row].pathToImage as UIImage
        cell.projectName.text = self.feed[indexPath.row].title as String
        cell.proDes.text = self.feed[indexPath.row].projectDescription as String
    
        return cell
        
        
    }
    
       
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
