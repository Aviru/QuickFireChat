//
//  DataController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/10/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseUserSystem {
    
    static let system = FirebaseUserSystem()
    
    // MARK: - Firebase references
    
    /** The base Firebase reference */
    let DATABASE_REF = Database.database().reference()
    /* The user Firebase reference */
    let USER_REF = Database.database().reference().child("users")
    
    
    /** The base Firebase storage reference */
    let FIR_STORAGE = Storage.storage()
    let STORAGE_REF = Storage.storage().reference()
    
    
    /** The Firebase reference to the current user tree */
    var CURRENT_USER_REF: DatabaseReference {
        let id = Auth.auth().currentUser!.uid
        return USER_REF.child("\(id)")
    }
    
    /** The Firebase reference to the current user's friend tree */
    var CURRENT_USER_FRIENDS_REF: DatabaseReference {
        let id = Auth.auth().currentUser!.uid
        return DATABASE_REF.child("friends").child("\(id)")
    }
    
    /** The Firebase reference to the current user's friend request tree */
    var CURRENT_USER_REQUESTS_REF: DatabaseReference {
        let id = Auth.auth().currentUser!.uid
        return DATABASE_REF.child("requests").child("\(id)")
    }
    
    /** The current user's id */
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }

    
    /** Gets the current User object for the specified user id */
    func getCurrentUser(_ completion: @escaping (ModelUserInfo) -> Void) {
        CURRENT_USER_REF.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
          
            //let email = snapshot.childSnapshot(forPath: "email").value as! String
           // let id = snapshot.key
             //User(userEmail: email, userID: id)
            
            if snapshot.exists(){
                
                if let usersDictionary = snapshot.value as? NSDictionary{
                    
                    print("UsersDictionary: \(usersDictionary)")
                    
                    let objUser = ModelUserInfo.init(infoDic: usersDictionary)
                    completion(objUser)
                }
            }
        })
    }
    /** Gets the User object for the specified user id */
    func getUser(_ userID: String, completion: @escaping (ModelUserInfo?,_ isDataRetrieved: Bool, _ error: CustomError?) -> Void) {
        USER_REF.child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                if let usersDictionary = snapshot.value as? NSDictionary{
                    
                    print("UsersDictionary: \(usersDictionary)")
                    
                    let objUser = ModelUserInfo.init(infoDic: usersDictionary)
                    let data = NSKeyedArchiver.archivedData(withRootObject: objUser)
                    
                    if GlobalUserDefaults.saveObject(obj: data as AnyObject, key: "UserInfo"){
                        
                        print("saved to UserDefaults")
                    }
                    else{
                        
                        print("unable to save UserDefaults")
                    }

                    
                    completion(objUser,true,nil)
                }
            }
            else {
                
                let custError =  CustomError.init(localizedTitle: "Error", Desc: "Error in retrieving user details from Firebase", code: 10005)
                
                return completion(nil,false,custError)
            }

        })
    }
    
    
    
    // MARK: - Account Related
    
    /**
     Creates a new user account with the specified email and password
     - parameter completion: What to do when the block has finished running. The success variable 
     indicates whether or not the signup was a success
     */
    func createAccount(email: String, password: String, completion: @escaping (_ user : User?, _ success: Bool ,_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if (error == nil) {
                // Success
                /*
                 var userInfo = [String: AnyObject]()
                 userInfo = ["email": email as AnyObject, "name": name as AnyObject]
                 self.CURRENT_USER_REF.setValue(userInfo)
                 */
                completion(user,true,nil)
            } else {
                // Failure
                completion(user,false,error)
            }
            
        })
    }
    
    /**
     Logs in an account with the specified email and password
     
     - parameter completion: What to do when the block has finished running. The success variable
     indicates whether or not the login was a success
     */
    func loginAccount( email: String, password: String, completion: @escaping (_ user : User?, _ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if (error == nil) {
                // Success
                completion(user,true,nil)
            } else {
                // Failure
                completion(user,false,error)
                print(error!)
            }
            
        })
    }
    
    /** Logs out an account */
    func logoutAccount() {
        try! Auth.auth().signOut()
    }
    
    
     // MARK: - Get User from Firebase
    
    func getUserFromFirebaseDB(user : User,handler : @escaping ( _ isDataRetrieved: Bool, _ error: CustomError?)-> Void){
        
        DATABASE_REF.child("users").queryOrdered(byChild: "userId")
            .queryEqual(toValue: user.uid).observeSingleEvent(of: .value, with: { snapshot in
                
                if snapshot.value == nil{
                    
                    let custError =  CustomError.init(localizedTitle: "Error", Desc: "Error in retrieving user details from Firebase", code: 10005)
                    
                    return handler(false,custError)
                }
                
                
                for snap in snapshot.children {
                    let userSnap = snap as! DataSnapshot
                   // let uid = userSnap.key //the uid of each user
                    if let postDict = userSnap.value as? [String:AnyObject] {
                        
                        print("User Details from DB = \( postDict)")
                        
                       // let Dict = ["email" : postDict["email"] as! String, "imageUrl" : postDict["imageUrl"] as! String, "userId" : postDict["userId"] as! String, "userName" : postDict["userName"] as! String]
                        
                        // Storing the dictionary
                        let objUser = ModelUserInfo.init(infoDic: postDict as NSDictionary)
                        let data = NSKeyedArchiver.archivedData(withRootObject: objUser)
                        
                        
                        if GlobalUserDefaults.saveObject(obj: data as AnyObject, key: "UserInfo"){
                            
                            print("saved to UserDefaults")
                        }
                        else{
                            
                            print("unable to save UserDefaults")
                        }
                        
                    }
                    
                }
                
                
                return handler(true,nil)
            })
    }
    
    // MARK: - Save Image to Firebase
    
    func saveUserToFirebaseDB(userName : String,imageDownloadedURL : String , user : User, handler : @escaping ( _ isDataSaved: Bool, _ error: Error?)-> Void){
        
        let dictionaryUser = [ "userName" : userName ,
                               "email" : user.email!,
                               "userId" : user.uid,
                               "imageUrl" : imageDownloadedURL,
                               ] as [String : Any]
        
        USER_REF.childByAutoId().setValue(dictionaryUser) { (error, dbReference) in
            
            if error != nil {
                
                return handler(false,error)
            }
            
            // Storing the dictionary
            let objUser = ModelUserInfo.init(infoDic: dictionaryUser as NSDictionary)
            let data = NSKeyedArchiver.archivedData(withRootObject: objUser)
            
            if GlobalUserDefaults.saveObject(obj: data as AnyObject, key: "UserInfo"){
                
                print("saved to UserDefaults")
            }
            else{
                
                print("unable to save UserDefaults")
            }
            
            return handler(true,nil)
        }
    }
    
    
    //MARK: - Save Image to Firebase Storage
    
    func saveImageToFirebase(userProfileImage : UIImage?,imageName : String? ,imageData : Data?, user : User, handler : @escaping (_ imgURL : String, _ isImageSaved: Bool, _ error: CustomError? )-> Void) {
        
            var imgName : String!
            var imgData : Data!
            
            /*
            ///Closure in Swift
            
            let isImage1EqualImage2 =  {(strImg1Name : String?, img1 : UIImage?, img2 : UIImage?) -> Bool in
                
                var isValid : Bool = false
                
                if strImg1Name != nil {
                    
                    if let firstImage = UIImage(named: strImg1Name!) {
                        let firstImgData = UIImagePNGRepresentation(firstImage)
                        let secondImageData = UIImagePNGRepresentation(img2!)
                        
                        if let firstData = firstImgData, let secondData = secondImageData {
                            
                            if firstData == secondData {
                                // 1st image is the same as 2nd image
                                isValid = true
                            } else {
                                // 1st image is not equal to 2nd image
                                isValid = false
                            }
                        } else {
                            // Creating NSData from Images failed
                            isValid = false
                        }
                    }
                }
                else {
                    
                    let firstImgData = UIImagePNGRepresentation(img1!)
                    
                    let secondImageData = UIImagePNGRepresentation(img2!)
                    
                    if let firstData = firstImgData, let secondData = secondImageData {
                        
                        if firstData == secondData {
                            // 1st image is the same as 2nd image
                            isValid = true
                        } else {
                            // 1st image is not equal to 2nd image
                            isValid = false
                        }
                    } else {
                        // Creating NSData from Images failed
                        isValid = false
                    }
                    
                }
                
                return isValid
            }
            
            /// Closure call
            
            let status = isImage1EqualImage2(nil, placeHolderImage, userProfileImage!)
 */
            
            if imageData == nil {
                
                imgName = "img_\(Date().timeIntervalSince1970)"
                imgData = UIImagePNGRepresentation(userProfileImage!)
            }
            else {
                
                imgName = imageName!
                imgData = imageData!
            }
        
            let imagesRef = STORAGE_REF.child("profileImages/\(user.uid)/\(imgName!)")
            
            // This is equivalent to creating the full reference
            let storagePath = "\(Constants.kFirebaseStorageURL)/\(imagesRef)"
            
            let finalStorageRef : StorageReference = FIR_STORAGE.reference(forURL: storagePath)
            
            
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/*"
            
            guard let imgeData = imgData else {
                
                let custError =  CustomError.init(localizedTitle: "Error", Desc: "Image not available", code: 10002)
                
                return handler("",false,custError)
            }
            
            // Upload file and metadata
            finalStorageRef.putData(imgeData, metadata: metadata, completion: { (metadata, error) in
                
                if error != nil {
                    
                     let custError = CustomError.init(localizedTitle: "Error", Desc: (error?.localizedDescription)!, code: 10003)
                    
                    return handler("",false, custError)
                }
                
                guard let downloadURL = metadata?.downloadURL()?.absoluteString else{
                    
                    let custError = CustomError.init(localizedTitle: "Error", Desc: "Image Download URL not available", code: 10003)
                    
                    return handler("",false,custError)
                }
                
                print("Response after image upload:\(metadata!)")
                
                return handler(downloadURL,true,nil)
            })
            
            
            /////////For Monitoring Upload Progress//////////
            
            /*
             // Listen for state changes, errors, and completion of the upload.
             uploadTask.observe(.resume) { snapshot in
             // Upload resumed, also fires when the upload starts
             }
             
             uploadTask.observe(.pause) { snapshot in
             // Upload paused
             }
             
             uploadTask.observe(.progress) { snapshot in
             // Upload reported progress
             let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
             / Double(snapshot.progress!.totalUnitCount)
             }
             
             uploadTask.observe(.success) { snapshot in
             // Upload completed successfully
             }
             
             uploadTask.observe(.failure) { snapshot in
             if let error = snapshot.error as? NSError {
             switch (StorageErrorCode(rawValue: error.code)!) {
             case .objectNotFound:
             // File doesn't exist
             break
             case .unauthorized:
             // User doesn't have permission to access file
             break
             case .cancelled:
             // User canceled the upload
             break
             
             /* ... */
             
             case .unknown:
             // Unknown error occurred, inspect the server response
             break
             default:
             // A separate error occurred. This is a good place to retry the upload.
             break
             }
             }
             }
             */
        
    }

    
    
    // MARK: - Request System Functions
    
    /** Sends a friend request to the user with the specified id */
    func sendRequestToUser(_ userID: String) {
        USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).setValue(true)
    }
    
    /** Unfriends the user with the specified id */
    func removeFriend(_ userID: String) {
        CURRENT_USER_REF.child("friends").child(userID).removeValue()
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).removeValue()
    }
    
    /** Accepts a friend request from the user with the specified id */
    func acceptFriendRequest(_ userID: String) {
        CURRENT_USER_REF.child("requests").child(userID).removeValue()
        CURRENT_USER_REF.child("friends").child(userID).setValue(true)
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).setValue(true)
        USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).removeValue()
    }
    
    
    
    // MARK: - All users
    /** The list of all users */
    //var userList = [User]()
    var userList = [ModelUserInfo]()
    /** Adds a user observer. The completion function will run every time this list changes, allowing you  
     to update your UI. */
    func addUserObserver(_ update: @escaping (_ isDataAvailable: Bool,
        _ error: CustomError?) -> Void) {
        
        FirebaseUserSystem.system.USER_REF.observe(DataEventType.value, with: { (snapshot) in
            
            self.userList.removeAll()
            
            if snapshot.exists(){
                
                for snap in snapshot.children {
                    let userSnap = snap as! DataSnapshot
                    if let usersDictionary = userSnap.value as? [String:AnyObject] {
                        
                        let objUser = ModelUserInfo.init(infoDic: usersDictionary as NSDictionary)
                        let outData = GlobalUserDefaults.getObjectWithKey("UserInfo")
                        let objUserInfo : ModelUserInfo = NSKeyedUnarchiver.unarchiveObject(with: outData as! Data) as! ModelUserInfo
                        
                        if objUserInfo.strUserId != objUser.strUserId {
                            
                            self.userList.append(objUser)
                        }
                    }
                }
                /*
                 if let usersDictionary = snapshot.value as? NSDictionary{
                 
                 print("UsersDictionary: \(usersDictionary)")
                 
                 for _ in usersDictionary{
                 
                 let objUser = ModelUserInfo.init(infoDic: usersDictionary)
                 let outData = GlobalUserDefaults.getObjectWithKey("UserInfo")
                 let objUserInfo : ModelUserInfo = NSKeyedUnarchiver.unarchiveObject(with: outData as! Data) as! ModelUserInfo
                 
                 if objUserInfo.strUserId != objUser.strUserId {
                 
                 self.userList.append(objUser)
                 }
                 
                 }
                 }
                 */
                
                return update(true,nil)
            }
                else {
                
                    let custError =  CustomError.init(localizedTitle: "Error", Desc: "Error in retrieving user List from Firebase", code: 10014)
                    
                    return update(false,custError)
                }
                
            })
        { (error) in
            
             let custError =  CustomError.init(localizedTitle: "Error", Desc: error.localizedDescription, code: 10014)
            
            print(error.localizedDescription)
            
            return update(false,custError)
            
        }
        
        
        /*
         for child in snapshot.children.allObjects as! [DataSnapshot] {
         let email = child.childSnapshot(forPath: "email").value as! String
         if email != Auth.auth().currentUser?.email! {
         // self.userList.append(User(userEmail: email, userID: child.key))
         let postDict = snapshot.value as! [String : AnyObject]
         self.userList.append(postDict)
         
         }
         }
         
         */
        
    }
    
    
    /** Removes the user observer. This should be done when leaving the view that uses the observer. */
    func removeUserObserver() {
        USER_REF.removeAllObservers()
    }
    
    
    
    // MARK: - All friends
    /** The list of all friends of the current user. */
    var friendList = [ModelUserInfo]()
    /** Adds a friend observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addFriendObserver(_ update: @escaping (_ isDataRetrieved: Bool, _ error: CustomError?) -> Void) {
        CURRENT_USER_FRIENDS_REF.observe(DataEventType.value, with: { (snapshot) in
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                
                self.getUser(id, completion: { (objUserInfo, success, error) in
                    
                    if success == true {
                        
                        self.friendList.append(objUserInfo!)
                        return update(true,nil)
                    }
                    else {
                        
                        let custError =  CustomError.init(localizedTitle: "Error", Desc: "Error in retrieving Friend List from Firebase", code: 10011)
                        
                        return update(false,custError)
                    }
                    
                })
                
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                
                 let custError =  CustomError.init(localizedTitle: "Error", Desc: "No Friend List available from Firebase", code: 10012)
                
               return update(false,custError)
            }
        })
    }
    
    // MARK: - Add Friend Request to Firebase
    
    func addFriendRequestToFirebaseDB(requestModel : ModelFriendRequest, handler : @escaping ( _ isDataSaved: Bool, _ error: Error?)-> Void){
        
        let dictionaryUser = [ "senderId" : requestModel.strSenderId! ,
                               "receiverId" : requestModel.strReceiverId!,
                               "status" : requestModel.strRequestStatus!,
                               ] as [String : Any]
        
        ///Add SenderId as Key and dictionaryUser as coresponding values under "request" to DB for Friend request
        
        CURRENT_USER_REQUESTS_REF.childByAutoId().setValue(dictionaryUser) { (error, dbReference) in
            
            if error != nil {
                
                return handler(false,error)
            }
            else {
                
                ///Add receiverId as Key and dictionaryUser as coresponding values under "request" to DB for Friend request
                
                let receiverid = requestModel.strReceiverId!
                self.DATABASE_REF.child("requests").child("\(receiverid)").setValue(dictionaryUser, withCompletionBlock: { (error, dbReference) in
                    
                    if error != nil {
                        
                        return handler(false,error)
                    }
                    return handler(true,nil)
                    
                })
            }
            
        }
    }

    /** Removes the friend observer. This should be done when leaving the view that uses the observer. */
    func removeFriendObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }

    // MARK: - All requests
    /** The list of all friend requests the current user has. */
    var requestList = [ModelFriendRequest]()
    /** Adds a friend request observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addRequestObserver(_ update: @escaping (_ isDataRetrieved: Bool, _ error: CustomError?) -> Void) {
        CURRENT_USER_REQUESTS_REF.observe(DataEventType.value, with: { (snapshot) in
            self.requestList.removeAll()
            
            if snapshot.exists(){
                
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let frndRequestSnap = child
                    if let frndRequestDictionary = frndRequestSnap.value as? [String:AnyObject] {
                        
                        let objFrndReqModel = ModelFriendRequest.init(infoDic: frndRequestDictionary as NSDictionary)
                        
                        self.requestList.append(objFrndReqModel)
                        
                        /*
                          let id = child.key
                        self.getUser(id, completion: { (objUserInfo, success, error) in
                            
                            if success == true {
                                
                                self.requestList.append(objUserInfo!)
                                return update(true,nil)
                            }
                            else {
                                
                                let custError =  CustomError.init(localizedTitle: "Error", Desc: "Error in retrieving Friend Request List from Firebase", code: 10013)
                                
                                return update(false,custError)
                            }
                            
                        })
                        */
                        
                    }

                }
                
                return update(true,nil)
            }
            
            
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                let custError =  CustomError.init(localizedTitle: "Error", Desc: "No Friend Request List available from Firebase", code: 10014)
                
                return update(false,custError)
            }
        })
    }
    /** Removes the friend request observer. This should be done when leaving the view that uses the observer. */
    func removeRequestObserver() {
        CURRENT_USER_REQUESTS_REF.removeAllObservers()
    }

    
}



