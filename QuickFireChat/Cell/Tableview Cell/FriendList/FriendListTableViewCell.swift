//
//  FriendListTableViewCell.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 09/07/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVwUser: UIImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var lblTyping: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
