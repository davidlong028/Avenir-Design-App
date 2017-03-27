//
//  FeedCell.swift
//  avenir-design-app
//
//  Created by I AM PR Agency on 3/24/17.
//  Copyright © 2017 Avenir Design. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var proDes: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func viewChatButton(_ sender: Any) {
        
    }
}
