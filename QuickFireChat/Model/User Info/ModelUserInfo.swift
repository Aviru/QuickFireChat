//
//  ModelUserInfo.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 09/07/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class ModelUserInfo: NSObject,NSCoding {
    
    var strImageUrl: String?
    var strUserEmail: String?
    var strUserId: String?
    var strUserName: String?
    
    // MARK: NSCoding
    
    init(ImageUrl : String, UserEmail: String, UserId : String, UserName : String) {
        self.strImageUrl = ImageUrl
        self.strUserEmail = UserEmail
        self.strUserId = UserId
        self.strUserName = UserName
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let ImageUrl = decoder.decodeObject(forKey: "imageUrl") as? String,let UserEmail = decoder.decodeObject(forKey: "email") as? String,let UserId = decoder.decodeObject(forKey: "userId") as? String,let UserName = decoder.decodeObject(forKey: "userName") as? String
            else {
                return nil
        }
        
        self.init(ImageUrl : ImageUrl, UserEmail: UserEmail, UserId : UserId, UserName : UserName)
    }
    
    
    func encode(with aCoder: NSCoder)  {
        aCoder.encode(self.strImageUrl, forKey: "imageUrl")
        aCoder.encode(self.strUserEmail, forKey: "email")
        aCoder.encode(self.strUserId, forKey: "userId")
        aCoder.encode(self.strUserName, forKey: "userName")
    }
    
    init(infoDic: NSDictionary) {
        
        if let imgUrl = infoDic["imageUrl"] as? String
        {
            self.strImageUrl = imgUrl
        }
        else
        {
            self.strImageUrl = ""
        }
        
        if let Email = infoDic["email"] as? String
        {
            self.strUserEmail = Email
        }
        else
        {
            self.strUserEmail = ""
        }
        
        if let userId = infoDic["userId"]as? String
        {
            self.strUserId = userId
        }
        else
        {
            self.strUserId = ""
        }
        
        if let strName = infoDic["userName"]as? String
        {
            self.strUserName = strName
        }
        else
        {
            self.strUserName = ""
        }
        
    }

}
