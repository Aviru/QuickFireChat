//
//  FriendListVC.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 09/07/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class FriendListVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var tblFriendList: UITableView!
    
    @IBOutlet var lblNoFriends: UILabel!
    
    
    var isLandscape : Bool! = false
    var progressHUD : ProgressHUD! = nil
    var arrFriendList: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.progressHUD = ProgressHUD(text: "Loading...")
        self.view.addSubview(self.progressHUD)
        
        FirebaseUserSystem.system.addFriendObserver { (isFriendListAvailable, error) in
            
            if error == nil {
                
                self.progressHUD.hide()
                
                print("Friends Array: \(FirebaseUserSystem.system.friendList)")
                
                if FirebaseUserSystem.system.userList.count > 0 {
                    
                    self.tblFriendList.isHidden = false
                    self.lblNoFriends.isHidden = true
                    self.tblFriendList.reloadData()
                }
                else {
                    
                    self.tblFriendList.isHidden = true
                    self.lblNoFriends.isHidden = false
                }
                
            }
            else {
                
                self.progressHUD.hide()
                if(error?.Description == "No Friend List available from Firebase"){
                    self.tblFriendList.isHidden = true
                    self.lblNoFriends.isHidden = false
                }
                else{
                    self.showAlertMessage(titl: "Error", msg:  (error?.Description)!, displayTwoButtons: false)
                }
                return
            }
        }
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
        case .landscapeRight:
            text="LandscapeRight"
            isLandscape = true
        default:
            text="Another"
            isLandscape = false
        }
        NSLog("You have moved: \(text)")
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isLandscape == true {
            return 90.0;
        }
        else{
            return 75.0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FirebaseUserSystem.system.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FriendListTableViewCell = tblFriendList.dequeueReusableCell(withIdentifier: "friendListCell") as! FriendListTableViewCell!
        
        if isLandscape == true {
            cell.imgVwUser.layer.cornerRadius = UIScreen.main.bounds.size.width/2 * 0.08
        }
        else {
            cell.imgVwUser.layer.cornerRadius = UIScreen.main.bounds.size.width/2 * 0.13
        }
        cell.imgVwUser.clipsToBounds = true
        cell.selectionStyle = .none
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
