//
//  BaseViewController.swift
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 05/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

private let appDel = UIApplication.shared.delegate as! AppDelegate

protocol BaseVCAlertDelegate {
    
    func alertOkAction()
}


// MARK: - Extension

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}


// MARK: - Protocol

protocol OurErrorProtocol: Error {
    
    var localizedTitle: String { get }
    var Description: String { get }
    var code: Int { get }
}

// MARK: - Structure

struct appDelUserInfoModelObj {
    
    static var instanceOfUserInfoModelObject = appDel.objModelUserInfo
}


struct CustomError: OurErrorProtocol {
    
    var localizedTitle: String
    var Description: String
    var code: Int
    
    init(localizedTitle: String?, Desc: String, code: Int) {
        self.localizedTitle = localizedTitle ?? "Error"
        self.Description = Desc
        self.code = code
    }
}

struct Constants {
    static let kFirebaseStorageURL = "gs://fir-chatdemo-c5c22.appspot.com/"
}


/*
 extension String {
 func condenseWhitespace() -> String {
 return self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
 .filter { !$0.isEmpty }
 .joined(separator: " ")
 }
 }
 
 extension CGRect{
 init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
 self.init(x:x,y:y,width:width,height:height)
 }
 
 }

 
 extension CGSize{
 init(_ width:CGFloat,_ height:CGFloat) {
 self.init(width:width,height:height)
 }
 }
 extension CGPoint{
 init(_ x:CGFloat,_ y:CGFloat) {
 self.init(x:x,y:y)
 }
 }

 */

//MARK: -

 class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK:- Back Button
    
    @IBAction func btnBackAction(_ sender: Any) {
        
         _ = self.navigationController?.popViewController(animated: true)
    }
    

     //MARK:- Validate Email
    
    func validateEmail(_ tempMail : String) -> Bool {
        
        let stricterFilterString : String = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
       // let laxString : String = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = stricterFilterString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with:tempMail)
        
    }
    
    /*
    func startActivity(view : UIView) -> UIActivityIndicatorView {
        
        let activityView : UIActivityIndicatorView  = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
        view.isUserInteractionEnabled = false
        activityView.startAnimating()
        return activityView
    }
    
    func stopActivity(view : UIView) -> UIActivityIndicatorView {
        
        let activityView : UIActivityIndicatorView = activityForView(view: view)
        activityView.center=view.center
        view.addSubview(activityView)
        view.isUserInteractionEnabled = true
        activityView.stopAnimating()
        return activityView
    }
    
    func activityForView(view : UIView) -> UIActivityIndicatorView {
        
        var activity : UIActivityIndicatorView? = nil
        
        for subView in view.subviews {
            // Manipulate the view
            
            if let subVw = subView as? UIActivityIndicatorView {
                
                 activity = subVw
            }
        }
        
        return activity!
    }
 */
    
    //MARK:-  Show alert
    
    func showAlertMessage(titl : String, msg : String, displayTwoButtons : Bool) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: titl, message: msg, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(okAction)
        
        if displayTwoButtons {
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            
            actionSheetController.addAction(cancelAction)
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
   //MARK:- - Password Check
    
    func checkTextSufficientComplexity( text : String) -> Bool{
        
        
        let text = text
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        if (capitalresult && numberresult && specialresult) {
            
            return true
        }
        else{
            
            return false
        }
        
    }
    
    //MARK:- Compare Images
    
    public func isFirstImageEqualToSecondImage(image1Name strImg1Name : String?, image1 img1 : UIImage?, image2 img2 : UIImage) -> Bool {
        
        var isValid : Bool = false
        
        if strImg1Name != nil {
            
            if let firstImage = UIImage(named: strImg1Name!) {
                let firstImgData = UIImagePNGRepresentation(firstImage)
                let secondImageData = UIImagePNGRepresentation(img2)
                
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
            
            let secondImageData = UIImagePNGRepresentation(img2)
            
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
    
     //MARK:- Device Orientation
    
    func isDeviceOrientationLandscape() -> Bool {
        
        let size: CGSize = UIScreen.main.bounds.size
        if (size.width / size.height > 1) {
            return true
        } else {
            return false
        }
    }
    
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
    
    /*
     func isContainLowerCase(checkString : String) -> Bool {
     
     let stricterFilterString : String! = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}"
     let passwordTest : NSPredicate! = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
     //get all uppercase character set
     let cset : NSCharacterSet! = NSCharacterSet.lowercaseLetters
     //Find range for uppercase letters
     let rangeOfSearchString:NSRange! = checkString.rangeOfCharacter(from: cset)
     //check it conatins or not
     if rangeOfSearchString.location != Foundation.NSNotFound {
     
     print("not found any capital letters")
     return false
     }
     else{
     
     print("found capital letters")
     
     return true
     }
     
     return false
     }
     
     func isContainSpecialCase(checkString : String) -> Bool {
     
     let stricterFilterString : String! = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}"
     let passwordTest : NSPredicate! = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
     let specialCharacterString : String! = "!~`@#$%^&*-+();:={}[],.<>?\\/\"\'"
     let specialCharacterSet : NSCharacterSet! = NSCharacterSet(charactersIn: specialCharacterString)
     if  checkString.lowercased() .rangeOfCharacter(from: specialCharacterSet) {
     
     print("contains special characters")
     
     return true
     }
     else{
     
     print("NOT contains special characters")
     
     return false
     }
     
     }
     
     func isLengthMoreThan6(checkString : String) -> Bool {
     
     
     }
     
     func isContainDigit(checkString : String) -> Bool {
     
     let digit : String! = "01234567890"
     let digitSet: NSCharacterSet! = NSCharacterSet(charactersIn: digit)
     if checkString.lowercased().rangeOfCharacter(from: digitSet) {
     
     print("contains digit characters");
     return true;
     }
     else{
     
     print("NOT contains digit characters");
     return false;
     
     }
     }
     #pragma mark
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
