//
//  ModelFriendRequest.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 24/07/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class ModelFriendRequest: NSObject {
    
    var strSenderId: String?
    var strReceiverId: String?
    var strRequestStatus: String?
    
    init(infoDic: NSDictionary) {
        
        if let senderid = infoDic["senderId"] as? String
        {
            self.strSenderId = senderid
        }
        else
        {
            self.strSenderId = ""
        }
        
        if let receiverid = infoDic["receiverId"] as? String
        {
            self.strReceiverId = receiverid
        }
        else
        {
            self.strReceiverId = ""
        }
        
        if let status = infoDic["status"]as? String
        {
            self.strRequestStatus = status
        }
        else
        {
            self.strRequestStatus = ""
        }
        
    }


}
