//
//  UserListVC.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 24/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class DashboardVC: BaseViewController,UIScrollViewDelegate {
    
    @IBOutlet var imgVwUser: UIImageView!
    
    @IBOutlet var activityIndicatorUserImg: UIActivityIndicatorView!
    
    @IBOutlet var VwUnderlineUsers: UIView!
    
    @IBOutlet var VwUnderlineFriends: UIView!
    
    @IBOutlet var scrllVw: UIScrollView!
    
    @IBOutlet var VwScrollVwContainer: UIView!
    
    @IBOutlet var widthConstraintImgVwUser: NSLayoutConstraint!
    
    var isLandscape : Bool! = false
    var isUsersBtnTap,isFriendsBtnTap : Bool!
    var pageIndex : Int = 0
    
    var progressHUD : ProgressHUD! = nil
    var arrUsers: NSMutableArray = []
    var objUserInfo : ModelUserInfo!
    var userlistObj : UserListVC!
    var friendlistObj : FriendListVC!
    var lastOffset : CGPoint!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        isUsersBtnTap = true
        isFriendsBtnTap = false
        
        let outData = GlobalUserDefaults.getObjectWithKey("UserInfo")
        objUserInfo = NSKeyedUnarchiver.unarchiveObject(with: outData as! Data) as! ModelUserInfo
        
        VwUnderlineUsers.isHidden = false
        VwUnderlineFriends.isHidden = true
        
        userlistObj = self.storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
        userlistObj.view.frame = CGRect.init(x: 0, y: 0, width: VwScrollVwContainer.frame.size.width, height: VwScrollVwContainer.frame.size.height)
        self.addChildViewController(userlistObj)
        scrllVw.addSubview(userlistObj.view)
        userlistObj.didMove(toParentViewController: self)
        
        activityIndicatorUserImg.startAnimating()
        imgVwUser .sd_setImage(with:  URL(string: objUserInfo.strImageUrl!), placeholderImage: UIImage(named: "avatar.png"), options: SDWebImageOptions(rawValue: 0), progress: { (receivedSize, expectedSize, imageURL) in
            
        }) { (image, error, cacheType, imageURL) in
            self.activityIndicatorUserImg.stopAnimating()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrllVw.bounces = false
        scrllVw.isScrollEnabled = true;
        scrllVw.isPagingEnabled = true;
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        /*
        if isDeviceOrientationLandscape() {
            print("Landscape")
            
            isLandscape = true
            
        } else {
            print("Portrait")
            
            isLandscape = false
        }
 */
        
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
    
    override func viewDidLayoutSubviews() {
        
        imgVwUser.layer.cornerRadius = imgVwUser.frame.size.width/2
        imgVwUser.clipsToBounds = true
        
        scrllVw.frame = CGRect.init(x: 0, y: 0, width: VwScrollVwContainer.frame.size.width, height: VwScrollVwContainer.frame.size.height)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrllVw.contentSize = CGSize(width: scrllVw.frame.size.width * 2, height: scrllVw.frame.size.height - 200)
        }
        else
        {
            scrllVw.contentSize = CGSize(width: scrllVw.frame.size.width * 2, height: scrllVw.frame.size.height - 50)
        }
        
        
        var frame : CGRect
        if pageIndex == 1 {
            frame = CGRect.init()
            frame.origin.x = scrllVw.frame.size.width * 1;
            frame.origin.y = 0;
            pageIndex = 1;
            scrllVw.setContentOffset(CGPoint.init(x: frame.origin.x, y:  frame.origin.y), animated: true)
            friendlistObj.view.frame = CGRect.init(x: self.view.frame.size.width*1, y: 0, width: VwScrollVwContainer.frame.size.width, height: VwScrollVwContainer.frame.size.height)
        }
        else{
            frame = CGRect.init()
            frame.origin.x = scrllVw.frame.size.width * 0;
            frame.origin.y = 0;
            pageIndex = 0;
            scrllVw.setContentOffset(CGPoint.init(x: frame.origin.x, y:  frame.origin.y), animated: true)
            userlistObj.view.frame = CGRect.init(x: 0, y: 0, width: VwScrollVwContainer.frame.size.width, height: VwScrollVwContainer.frame.size.height)
        }
        
        //showSelectedViewController(offSet: CGPoint.init(x: frame.origin.x, y:  frame.origin.y))
    }
    
    //MARK:- ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("Scroll view content offset: \(NSStringFromCGPoint(scrllVw.contentOffset))")
        
        let nowOffset : CGPoint = scrllVw.contentOffset
        
        if ((lastOffset.x - nowOffset.x) < 0) {
            //uncomment to prevent scroll to left
           // scrllVw.isScrollEnabled = true
            
        }
        else if ((lastOffset.x - nowOffset.x) > 0) {
            //uncomment to prevent scroll to right
            //scrllVw.isScrollEnabled = true
        }
        else if ((lastOffset.x - nowOffset.x) == 0) {
            //uncomment to prevent scroll to right
            var frame : CGRect = CGRect.init()
            frame.origin.x = scrllVw.frame.size.width * 0;
            frame.origin.y = 0;
            pageIndex = 0;
            
            scrllVw.setContentOffset(CGPoint.init(x: frame.origin.x, y:  frame.origin.y), animated: true)
            showSelectedViewController(offSet: CGPoint.init(x: frame.origin.x, y:  frame.origin.y))
        }
        else {
          // scrllVw.isScrollEnabled = true
        }
        
        /*
        if scrllVw.contentOffset.x > self.view.frame.size.width {
            
            scrllVw.isScrollEnabled = false
        }
        else {
            
            scrllVw.isScrollEnabled = true
        }
        */
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrllVw.isScrollEnabled = true
        lastOffset = scrollView.contentOffset;
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
       showSelectedViewController(offSet: targetContentOffset.pointee)
    }
    
    func showSelectedViewController( offSet : CGPoint) {
        
        var offSet = offSet
        let pageWidth : Int = Int(scrllVw.frame.size.width)
        let pageX : Int =  pageIndex*pageWidth-Int(scrllVw.contentInset.left)
        
        if (Int(offSet.x) < pageX) {
            if (pageIndex>0) {
                pageIndex -= 1;
            }
        }
        else if(Int(offSet.x)>pageX){
            if (pageIndex<1) {
                pageIndex += 1;
            }
        }
        
        
        if (pageIndex <= 1) {
            
            offSet.x = CGFloat(pageIndex*pageWidth-Int(scrllVw.contentInset.left))
            
            if (pageIndex == 0) {
               
                VwUnderlineUsers.isHidden = false
                VwUnderlineFriends.isHidden = true
                
                userlistObj = self.storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
                userlistObj.view.frame = CGRect.init(x: 0, y: 0, width: VwScrollVwContainer.frame.size.width, height: VwScrollVwContainer.frame.size.height)
                self.addChildViewController(userlistObj)
                scrllVw.addSubview(userlistObj.view)
                userlistObj.didMove(toParentViewController: self)
            }
            if (pageIndex == 1) {
                
                VwUnderlineUsers.isHidden = true
                VwUnderlineFriends.isHidden = false
                
                friendlistObj = self.storyboard?.instantiateViewController(withIdentifier: "FriendListVC") as! FriendListVC
                friendlistObj.view.frame = CGRect.init(x: self.view.frame.size.width*1, y: 0, width: VwScrollVwContainer.frame.size.width, height: VwScrollVwContainer.frame.size.height)
                self.addChildViewController(friendlistObj)
                scrllVw.addSubview(friendlistObj.view)
                friendlistObj.didMove(toParentViewController: self)
            }
            
            
        }
        
        print("pageIndex: \(pageIndex) Offset: \(offSet.x)")
        
    }
    
    
    // MARK: - Button Action
    
    @IBAction func btnUsersAction(_ sender: Any) {
        
        VwUnderlineUsers.isHidden = false;
        VwUnderlineFriends.isHidden = true;
        
        var frame : CGRect = CGRect.init()
        frame.origin.x = scrllVw.frame.size.width * 0;
        frame.origin.y = 0;
        pageIndex = 0;
        
        scrllVw.setContentOffset(CGPoint.init(x: frame.origin.x, y:  frame.origin.y), animated: true)
        
        showSelectedViewController(offSet: CGPoint.init(x: frame.origin.x, y:  frame.origin.y))
        
    }
    
    @IBAction func btnFriendsAction(_ sender: Any) {
        
        VwUnderlineUsers.isHidden = true;
        VwUnderlineFriends.isHidden = false;
        
        var frame : CGRect = CGRect.init()
        frame.origin.x = scrllVw.frame.size.width * 1;
        frame.origin.y = 0;
        pageIndex = 1;
        
        scrllVw.setContentOffset(CGPoint.init(x: frame.origin.x, y:  frame.origin.y), animated: true)
        
        showSelectedViewController(offSet: CGPoint.init(x: frame.origin.x, y:  frame.origin.y))
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
