//
//  UserListTableViewCell.swift
//  QuickFireChat
//
//  Created by appsbee on 06/07/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVwUser: UIImageView!
    
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var imgVwFriendStatusIcon: UIImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var btnFriendOutlet: UIButton!
    
    var buttonFriendFunc: (() -> (Void))!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnFriendAction(_ sender: UIButton) {
        
        buttonFriendFunc()
    }
    
    func setButtonFriendTapFunction(_ function: @escaping () -> Void) {
        self.buttonFriendFunc = function
    }

}
