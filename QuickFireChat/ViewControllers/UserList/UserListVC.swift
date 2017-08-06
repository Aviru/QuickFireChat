//
//  UserListVC.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 10/07/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit
import SDWebImage

class UserListVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblUserList: UITableView!
    
    @IBOutlet var lblNoUsersAvailable: UILabel!
    
    var isLandscape : Bool! = false
    var progressHUD : ProgressHUD! = nil
    var arrUsers: NSMutableArray = []
    var arrFriends: NSMutableArray = []
    var objUserInfo : ModelUserInfo!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.progressHUD = ProgressHUD(text: "Loading...")
        self.view.addSubview(self.progressHUD)
        
        let outData = GlobalUserDefaults.getObjectWithKey("UserInfo")
        appDelUserInfoModelObj.instanceOfUserInfoModelObject = NSKeyedUnarchiver.unarchiveObject(with: outData as! Data) as? ModelUserInfo
        
        FirebaseUserSystem.system.addUserObserver { (isUserListAvailable, error) in
            
             self.progressHUD.hide()
            
            if error == nil {
                
                if isUserListAvailable == true{
                    
                    print("Users Array: \(FirebaseUserSystem.system.userList)")
                    
                    if FirebaseUserSystem.system.userList.count > 0 {
                        
                        self.tblUserList.isHidden = false
                        self.lblNoUsersAvailable.isHidden = true
                        self.tblUserList.reloadData()
                    }
                    else {
                        
                        self.tblUserList.isHidden = true
                        self.lblNoUsersAvailable.isHidden = false
                    }
                    
                }
                else{
                    
                    self.showAlertMessage(titl: "Error", msg:  (error?.Description)!, displayTwoButtons: false)
                    return
                }
                
            }
            else {
                
                self.showAlertMessage(titl: "Error", msg:  (error?.Description)!, displayTwoButtons: false)
                return
            }
        }
        
        FirebaseUserSystem.system.addRequestObserver({ (isRequestSuccess, error) in
            
            self.progressHUD.hide()
            
            if error == nil {
                
                self.tblUserList.reloadData()
            }
            else {
                
               // self.showAlertMessage(titl: "Error", msg:  (error?.Description)!, displayTwoButtons: false)
                return
            }
        })
        
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            isLandscape = false
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
            isLandscape = false
        case .landscapeLeft:
            text="LandscapeLeft"
            isLandscape = true
            tblUserList.reloadData()
        case .landscapeRight:
            text="LandscapeRight"
            isLandscape = true
            tblUserList.reloadData()
        default:
            text="Another"
            isLandscape = false
        }
        NSLog("You have moved: \(text)")
        
        
    }
    

    //MARK:- Get Users From Firebase DB
    
    func getUsersFromFirebaseDB(handler : @escaping ( _ isDataAvailable: Bool, _ arr : NSMutableArray, _ error: Error?)-> Void){
        
        let usersArr : NSMutableArray = []
        
        let parentRef = Database.database().reference()
        
        parentRef.child("users").observe(.value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                if let usersDictionary = snapshot.value as? NSDictionary{
                    
                    print("UsersDictionary: \(usersDictionary)")
                    
                    for _ in usersDictionary{
                        
                        let objUser = ModelUserInfo.init(infoDic: usersDictionary)
                        
                        if self.objUserInfo.strUserId != objUser.strUserId {
                            
                            usersArr.add(objUser)
                        }
                        
                    }
                    
                    return handler(true,usersArr,nil)
                }
            }
            else {
                
                let custError = CustomError.init(localizedTitle: "Error", Desc: "Users not available", code: 10006)
                
                return handler(false,usersArr,custError)
            }
            
        })
        { (error) in
            
            print(error.localizedDescription)
            
            return handler(false,usersArr, error)
        }
        
        /*
         parentRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
         
         if snapshot.exists(){
         
         if let usersDictionary = snapshot.value as? NSDictionary{
         
         print("UsersDictionary: \(usersDictionary)")
         
         for _ in usersDictionary{
         
         //                        let value = snapshot.value as? NSDictionary
         //                        let username = value?["username"] as? String ?? ""
         //                        let user = User.init(username: username)
         
         let objUser = ModelUserInfo.init(infoDic: usersDictionary)
         
         if self.objUserInfo.strUserId != objUser.strUserId {
         
         usersArr.add(objUser)
         }
         
         }
         
         return handler(true,usersArr,nil)
         }
         }
         
         }, withCancel: { (error) in
         
         print(error.localizedDescription)
         
         return handler(false,usersArr, error)
         
         })
         */
        
    }
    
    
     //MARK:- Get Friends From Firebase DB
    
    func getFriendsFromFirebaseDB(handler : @escaping ( _ isDataAvailable: Bool, _ arr : NSMutableArray, _ error: Error?)-> Void){
        
        let friendsArr : NSMutableArray = []
        
        let parentRef = Database.database().reference()
        
        parentRef.child("friends").observe(.value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                if let usersDictionary = snapshot.value as? NSDictionary{
                    
                    print("UsersDictionary: \(usersDictionary)")
                    
                    for _ in usersDictionary{
                        
                        let objUser = ModelUserInfo.init(infoDic: usersDictionary)
                        
                        if self.objUserInfo.strUserId != objUser.strUserId {
                            
                            friendsArr.add(objUser)
                        }
                        
                    }
                    
                    return handler(true,friendsArr,nil)
                }
            }
            else {
                
                let custError = CustomError.init(localizedTitle: "Error", Desc: "Friends not available", code: 10008)
                
                return handler(false,friendsArr,custError)
            }
            
        })
        { (error) in
            
            print(error.localizedDescription)
            
            return handler(false,friendsArr, error)
        }
    }
    
    // MARK:- UITableview Delegates and DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isLandscape == true {
            return 100.0;
        }
        else{
            return 90.0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FirebaseUserSystem.system.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserListTableViewCell = tblUserList.dequeueReusableCell(withIdentifier: "UserCell") as! UserListTableViewCell!
        
        if isLandscape == true {
            cell.imgVwUser.layer.cornerRadius = UIScreen.main.bounds.size.width/2 * 0.1
        }
        else {
            cell.imgVwUser.layer.cornerRadius = UIScreen.main.bounds.size.width/2 * 0.18
        }
        cell.imgVwUser.clipsToBounds = true
        
        let objUserModel:ModelUserInfo =  FirebaseUserSystem.system.userList[indexPath.row] 
        
        cell.lblUserName.text = objUserModel.strUserName
        
        cell.activityIndicator.startAnimating()
        cell.imgVwUser .sd_setImage(with:  URL(string: objUserModel.strImageUrl!), placeholderImage: UIImage(named: "avatar.png"), options: SDWebImageOptions(rawValue: 0), progress: { (receivedSize, expectedSize, imageURL) in
            
            
        }) { (image, error, cacheType, imageURL) in
            cell.activityIndicator.stopAnimating()
        }
        
        if  FirebaseUserSystem.system.requestList.count > 0 {
            
            if  FirebaseUserSystem.system.requestList.count > indexPath.row {
                
                for  objFrndReq:ModelFriendRequest in FirebaseUserSystem.system.requestList {
                    
                    if objFrndReq.strReceiverId == objUserModel.strUserId {
                        
                        if objFrndReq.strRequestStatus == "Pending" {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = false
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendRequestSent_icon.png")
                        }
                        else if  objFrndReq.strRequestStatus == "Rejected" {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = true
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendRequest_icon.png")
                        }
                        else if  objFrndReq.strRequestStatus == "Accepted" {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = false
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendAccept_icon.png")
                        }
                        else {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = true
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendRequest_icon.png")
                        }
                        
                    }
                    else if objFrndReq.strSenderId == objUserModel.strUserId {
                        
                        if objFrndReq.strRequestStatus == "Pending" {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = true
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendRequestIncoming_icon.png")
                        }
                        else if  objFrndReq.strRequestStatus == "Rejected" {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = false
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendReject_icon.png")
                        }
                        else if  objFrndReq.strRequestStatus == "Accepted" {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = false
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendAccept_icon.png")
                        }
                        else {
                            
                            cell.btnFriendOutlet.isUserInteractionEnabled = true
                            cell.imgVwFriendStatusIcon.image = UIImage(named: "FriendRequest_icon.png")
                        }
                        
                    }
                }
            }
        }
        else {
            
        }
        
         //cell.btnFriendOutlet .addTarget(self, action: #selector(btnFriendTap(_:)), for: .touchUpInside)
        
        cell.setButtonFriendTapFunction {
            
            if self.isFirstImageEqualToSecondImage(image1Name: "FriendRequest_icon.png", image1: nil, image2: cell.imgVwFriendStatusIcon.image!) {
                
                let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Do you want to send friend request?", preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                    //Just dismiss the action sheet
                    
                    self.progressHUD = ProgressHUD(text: "Loading...")
                    self.view.addSubview(self.progressHUD)
                    
                    let dictionaryRequest = [ "senderId" : appDelUserInfoModelObj.instanceOfUserInfoModelObject!.strUserId! ,
                                              "receiverId" : objUserModel.strUserId!,
                                              "status" : "Pending",
                                              ] as [String : Any]
                    
                    let objFrndRequest = ModelFriendRequest.init(infoDic: dictionaryRequest as NSDictionary)
                    
                    FirebaseUserSystem.system.addFriendRequestToFirebaseDB(requestModel: objFrndRequest, handler: { (isfriendAdded, error) in
                        
                        self.progressHUD.hide()
                        
                        if error == nil {
                            
                            self.showAlertMessage(titl: "", msg: "Friend Request sent successfully", displayTwoButtons: false)
                            
                            self.tblUserList.reloadData()
                            
                        }
                        else {
                            self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                            return
                        }
                    })
                    
                    
                    actionSheetController.dismiss(animated: true, completion: nil)
                }
                actionSheetController.addAction(okAction)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
                    //Just dismiss the action sheet
                    actionSheetController.dismiss(animated: true, completion: nil)
                }
                actionSheetController.addAction(cancelAction)
                
                self.present(actionSheetController, animated: true, completion: nil)
                
            }
            else {
                
                if  FirebaseUserSystem.system.requestList.count > 0 {
                    for  objFrndReq:ModelFriendRequest in FirebaseUserSystem.system.requestList {
                        
                        if objFrndReq.strReceiverId == objUserModel.strUserId {
                            
                            if  objFrndReq.strRequestStatus == "Rejected" {
                                
                                let actionSheetController: UIAlertController = UIAlertController(title: "", message: "This User has already rejected your request. Do you want to send friend request again?", preferredStyle: .alert)
                                let okAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                                    //Just dismiss the action sheet
                                    
                                    self.progressHUD = ProgressHUD(text: "Loading...")
                                    self.view.addSubview(self.progressHUD)
                                    
                                    let dictionaryRequest = [ "senderId" : appDelUserInfoModelObj.instanceOfUserInfoModelObject!.strUserId! ,
                                                              "receiverId" : objUserModel.strUserId!,
                                                              "status" : "Pending",
                                                              ] as [String : Any]
                                    
                                    let objFrndRequest = ModelFriendRequest.init(infoDic: dictionaryRequest as NSDictionary)
                                    
                                    FirebaseUserSystem.system.addFriendRequestToFirebaseDB(requestModel: objFrndRequest, handler: { (isfriendAdded, error) in
                                        
                                        self.progressHUD.hide()
                                        
                                        if error == nil {
                                            
                                            self.showAlertMessage(titl: "", msg: "Friend Request sent successfully", displayTwoButtons: false)
                                            
                                            self.tblUserList.reloadData()
                                            
                                        }
                                        else {
                                            self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                                            return
                                        }
                                    })
                                    
                                    
                                    actionSheetController.dismiss(animated: true, completion: nil)
                                }
                                actionSheetController.addAction(okAction)
                                
                                let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
                                    //Just dismiss the action sheet
                                    actionSheetController.dismiss(animated: true, completion: nil)
                                }
                                actionSheetController.addAction(cancelAction)
                                
                                self.present(actionSheetController, animated: true, completion: nil)
                            }
                        }
                        
                        else if objFrndReq.strSenderId == objUserModel.strUserId {
                            
                            if objFrndReq.strRequestStatus == "Pending" {
                                
                                let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Do you want to Accept or Reject this request?", preferredStyle: .alert)
                                let okAction: UIAlertAction = UIAlertAction(title: "Accept", style: .default) { action -> Void in
                                    //Just dismiss the action sheet
                                    
                                    
                                    
                                    actionSheetController.dismiss(animated: true, completion: nil)
                                }
                                actionSheetController.addAction(okAction)
                                
                                let cancelAction: UIAlertAction = UIAlertAction(title: "Reject", style: .destructive) { action -> Void in
                                    //Just dismiss the action sheet
                                    actionSheetController.dismiss(animated: true, completion: nil)
                                }
                                actionSheetController.addAction(cancelAction)
                                
                                self.present(actionSheetController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    //MARK:- Button Action
    
     func btnFriendTap(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:tblUserList)
        let indexPath = tblUserList.indexPathForRow(at: buttonPosition)
        
        self.queryFirebaseDBAndAddFriend(indx: (indexPath?.row)!) { (status, error) in
            
            if status == true {
                
                if error == nil {
                    
                    
                }
                else {
                    
                    self.progressHUD.hide()
                    self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                    return
                }
            }
            else {
                
                self.progressHUD.hide()
                self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                return
            }
            
        }
    }
    
    
    //MARK:- Query Firebase DB and add Friend
    
    func queryFirebaseDBAndAddFriend(indx : Int, handler : @escaping ( _ isUserIdAvailable: Bool, _ error: Error?)-> Void){
        
        let parentRef = Database.database().reference()
        parentRef.child("users")
            .queryOrdered(byChild: "userId")
            .queryEqual(toValue: self.objUserInfo.strUserId)
            .observe(.value, with: { (snapshot) in
                
                 if snapshot.exists() {
                    
                    let dictionaryUser = ["status" : "pending"]
                    let recipientId = (self.arrUsers[indx] as AnyObject).object(forKey:"userId")
                    
                    let strFrndKey = String(format: "friend_%@_%@", self.objUserInfo.strUserId!,recipientId as! CVarArg)
                    
                     parentRef.child("friends").child(strFrndKey).setValue(dictionaryUser, withCompletionBlock: { (error, dbReference) in
                        
                        if error != nil {
                            
                            return handler(false,error)
                        }
                        
                        return handler(true,nil)
                        
                        
                     })
                }
                 else {
                    
                    let custError = CustomError.init(localizedTitle: "Error", Desc: "No such User available", code: 10009)
                    
                    return handler(false,custError)
                }
                
            })
            { (error) in
                
                print(error.localizedDescription)
                
                return handler(false, error)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
