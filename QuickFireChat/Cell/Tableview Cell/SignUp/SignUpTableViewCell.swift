//
//  SignUpTableViewCell.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 02/07/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVwIcon: UIImageView!
    
    @IBOutlet var txtCell1: UITextField!
    
    @IBOutlet var btnSignUp: RoundedButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
