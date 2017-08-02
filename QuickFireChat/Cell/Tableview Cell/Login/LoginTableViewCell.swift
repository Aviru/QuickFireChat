//
//  LoginTableViewCell.swift
//  QuickFireChat
//
//  Created by appsbee on 26/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class LoginTableViewCell: UITableViewCell {
    
    @IBOutlet var txtCell1: UITextField!
    
    @IBOutlet var imgVwForgotPassIcon: UIImageView!
    
    @IBOutlet var btnForgotPass: UIButton!
    
    @IBOutlet var imgVwIcon: UIImageView!
    
    @IBOutlet var btnLogin: RoundedButton!
    
    @IBOutlet var btnFbLogin: RoundedButton!
    
    @IBOutlet var btnSignUp: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
