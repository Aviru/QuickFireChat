//
//  GlobalUserDefaults.swift
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 05/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

@objc class GlobalUserDefaults: NSObject {
    
  @objc class func getObjectWithKey(_ key: String) -> AnyObject {
        
        let defaults : UserDefaults = getDefaults()
        var obj : AnyObject? = defaults.object(forKey: key) as AnyObject
        
        if (obj != nil) {
            return obj!
        }
        else{
           obj = nil
          return obj!
        }
        
    }
    
   @objc class func saveObject(obj : AnyObject, key : String) -> Bool {
        
        let defaults : UserDefaults = getDefaults()
        defaults .set(obj, forKey: key)
        defaults.synchronize()
        let obj : AnyObject? = defaults.object(forKey: key) as AnyObject
        
        if (obj != nil) {
            return true
        } else {
            return false
        }
        
    }
    
  @objc class func RemoveUserDefaultValueForKey(_ key : String) {
        
        let defaults : UserDefaults = getDefaults()
        let obj : AnyObject! = defaults.object(forKey: key) as AnyObject
        
        if (obj != nil) {
            defaults.removeObject(forKey: key)
        }
    }

   @objc class func getDefaults() -> UserDefaults {
        
        return UserDefaults.standard
    }
    
}
