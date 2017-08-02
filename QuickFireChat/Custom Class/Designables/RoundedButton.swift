//
//  RoundedButton.swift
//  QuickChatDemo
//
//  Created by appsbee on 05/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

@IBDesignable

class RoundedButton: UIButton {
    
    /*
    var cornerRadius : CGFloat?
    var borderWidth : CGFloat?
    var borderColor : UIColor?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        layer.cornerRadius = cornerRadius!
        layer.borderWidth = borderWidth!
        layer.borderColor = borderColor?.cgColor
        
    }
 */
    
    
     @IBInspectable var borderColor: UIColor = UIColor.clear {
     didSet {
     layer.borderColor = borderColor.cgColor
     }
     }
     
     @IBInspectable var borderWidth: CGFloat = 0 {
     didSet {
     layer.borderWidth = borderWidth
     }
     }
     
     @IBInspectable var cornerRadius: CGFloat = 0 {
     didSet {
     layer.cornerRadius = cornerRadius
     }
     }
     
     @IBInspectable var masksToBounds: Bool = false {
     didSet {
     layer.masksToBounds = masksToBounds
     }
     }

    
}
