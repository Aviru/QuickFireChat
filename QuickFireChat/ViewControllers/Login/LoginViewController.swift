//
//  LoginViewController.swift
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 05/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: BaseViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var txtUserName: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var btnLoginOutlet: RoundedButton!
    
    @IBOutlet var btnFBLoginOutlet: RoundedButton!
    
    @IBOutlet var tblLogin: UITableView!
    
    
    var isValidPassword,isValidEmail,whiteSpaceChracter : Bool!
    
    var strPassword = "",strUserName = ""
    
    var progressHUD : ProgressHUD! = nil
    
    // Data model: These strings will be the data for the table view cells
    var arrPlaceHolderValues: [String] = ["E-mail", "Password", ""]
     var arrIcons: [String] = ["mail.png", "password_icon.png",""]
    
    var imgName : String!
    var imageData : Data?
    var fbImage : UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if (FBSDKAccessToken.current() != nil) {
            
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        txtUserName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK:- Button Action
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
    }
    
    @IBAction func btnNormalLoginAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if alert() {
            
            self.progressHUD = ProgressHUD(text: "Loading...")
            self.view.addSubview(self.progressHUD)
            
            FirebaseUserSystem.system.loginAccount(email: strUserName, password: strPassword, completion: { (user, success, error) in
                
                if error != nil {
                    
                    self.progressHUD.hide()
                    self.showAlertMessage(titl: "Error", msg: (error?.localizedDescription)!, displayTwoButtons: false)
                    return
                }
                
                let firUser : User = user!
                
                FirebaseUserSystem.system.getUserFromFirebaseDB(user: firUser, handler: { (retrieveStatus, customError) in
                    
                    self.progressHUD.hide()
                    
                    if retrieveStatus == true{
                        
                        if GlobalUserDefaults.saveObject(obj: "YES" as AnyObject, key: "IsLoggedIn") {
                            
                            print("LoggedIn status saved to UserDefaults")
                        }
                        else{
                            
                            print("unable to LoggedIn status save UserDefaults")
                        }
                        
                        self.performSegue(withIdentifier: "showUserListFromLogin", sender: nil)
                    }
                    else{
                        
                        self.progressHUD.hide()
                        self.showAlertMessage(titl: "Error", msg:  (customError?.Description)!, displayTwoButtons: false)
                        return
                    }
                })
                
            })
        }
    }
    
    @IBAction func btnFBLoginAction(_ sender: Any) {
        
        self.progressHUD = ProgressHUD(text: "Loading...")
        self.view.addSubview(self.progressHUD)
        
        if (FBSDKAccessToken.current() != nil)
        {
            self.progressHUD.hide()
            FBSDKAccessToken.setCurrent(nil)
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        else
        {
            let requiredPermissions = ["public_profile", "email", "user_friends"]
            
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: requiredPermissions, from: self, handler: { (result, error) in
                
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(error != nil){
                    
                    self.progressHUD.hide()
                }
                    
                else if(fbloginresult.isCancelled){
                    
                    self.progressHUD.hide()
                }
                    
                else{
                    
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        
                        self.getFBUserDetails(handler: { (dict) in
                            
                            if (dict.isEmpty == false) {
                                
                                DispatchQueue.main.async {
                                    
                                    let fbUserDetails : [String: String] = dict
                                    print(fbUserDetails)
                                    
                                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                                    
                                    Auth.auth().signIn(with: credential) { (user, error) in
                                        
                                        if error != nil {
                                            
                                            self.progressHUD.hide()
                                            self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                                            
                                            return
                                        }
                                        // User is signed in
                                        // ...
                                        
                                        let firUser : User = user!
                                        
                                        print("user description:\(String(describing: firUser))")
                                        
                                        
                                        FirebaseUserSystem.system.getUserFromFirebaseDB(user: firUser, handler: { (retrieveStatus, customError) in
                                            
                                            self.progressHUD.hide()
                                            
                                            if retrieveStatus == true{
                                                
                                                if GlobalUserDefaults.saveObject(obj: "YES" as AnyObject, key: "IsLoggedIn") {
                                                    
                                                    print("LoggedIn status saved to UserDefaults")
                                                }
                                                else{
                                                    
                                                    print("unable to LoggedIn status save UserDefaults")
                                                }
                                                
                                                self.performSegue(withIdentifier: "showUserListFromLogin", sender: nil)
                                            }
                                            else{
                                                
                                                if let fbImgURL = URL(string: fbUserDetails["imageURL"]!){
                                                    
                                                    self.getImageFromUrl(url: fbImgURL , completion: { (imgData, response, error) in
                                                        
                                                        if error != nil {
                                                            
                                                            self.progressHUD.hide()
                                                            self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                                                            
                                                            return
                                                        }
                                                        
                                                        if imgData != nil{
                                                            
                                                            self.imageData = imgData
                                                            self.imgName = dict["facebookID"]
                                                            
                                                            FirebaseUserSystem.system.saveImageToFirebase(userProfileImage: nil, imageName: self.imgName, imageData: self.imageData, user: firUser, handler: { (uploadedImgURL, isImageSaved, customError) in
                                                                
                                                                if isImageSaved == true{
                                                                    
                                                                    FirebaseUserSystem.system.saveUserToFirebaseDB(userName: firUser.displayName!, imageDownloadedURL: firUser.photoURL!.absoluteString, user: firUser, handler: { (dataSavedStatus,error) in
                                                                        
                                                                        print("user description:\(String(describing: user!))")
                                                                        
                                                                        self.progressHUD.hide()
                                                                        
                                                                        if dataSavedStatus == true{
                                                                            
                                                                            if GlobalUserDefaults.saveObject(obj: "YES" as AnyObject, key: "IsLoggedIn") {
                                                                                
                                                                                print("LoggedIn status saved to UserDefaults")
                                                                            }
                                                                            else{
                                                                                
                                                                                print("unable to LoggedIn status save UserDefaults")
                                                                            }
                                                                            
                                                                            self.performSegue(withIdentifier: "showUserListFromLogin", sender: nil)
                                                                        }
                                                                        else{
                                                                            
                                                                            self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                                                                            
                                                                            return
                                                                        }
                                                                        
                                                                    })
                                                                }
                                                                else{
                                                                    
                                                                    self.progressHUD.hide()
                                                                    self.showAlertMessage(titl: "Error", msg:  (customError?.localizedDescription)!, displayTwoButtons: false)
                                                                    
                                                                    return
                                                                }
                                                                
                                                            })
                                                        }
                                                        else{
                                                            
                                                            self.progressHUD.hide()
                                                            self.showAlertMessage(titl: "", msg: "Something went wrong! Unable to download image", displayTwoButtons: false)
                                                        }
                                                        
                                                    })
                                                }
                                                else
                                                {
                                                    print("Facebook Image not available")
                                                    self.progressHUD.hide()
                                                    self.showAlertMessage(titl: "", msg: "Facebook image not available", displayTwoButtons: false)
                                                }
                                            }
                                        })
                                        
                                        
                                    }
                                    
                                }
                            }
                        })
                    }
                }
                
            })
        }
    }
    
    func btnRegisterTap(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "showSignUpSegue", sender: nil)
    }
    
    func btnLoginTap(_ sender: UIButton) {
        
        sender.convert(CGPoint.zero, to: self.tblLogin)
        
        self.view.endEditing(true)
        
        if alert() {
            
            self.progressHUD = ProgressHUD(text: "Loading...")
            self.view.addSubview(self.progressHUD)
            
            FirebaseUserSystem.system.loginAccount(email: strUserName, password: strPassword, completion: { (user, success, error) in
                
                if error != nil {
                    
                    self.progressHUD.hide()
                    self.showAlertMessage(titl: "Error", msg: (error?.localizedDescription)!, displayTwoButtons: false)
                    return
                }
                
                let firUser : User = user!
                
                FirebaseUserSystem.system.getUser(firUser.uid, completion: { (modelUserInfo, retrieveStatus, customError) in
                    
                    self.progressHUD.hide()
                    
                    if retrieveStatus == true{
                        
                        if GlobalUserDefaults.saveObject(obj: "YES" as AnyObject, key: "IsLoggedIn") {
                            
                            print("LoggedIn status saved to UserDefaults")
                        }
                        else{
                            
                            print("unable to LoggedIn status save UserDefaults")
                        }
                        
                        self.performSegue(withIdentifier: "showUserListFromLogin", sender: nil)
                    }
                    else{
                        
                        self.progressHUD.hide()
                        self.showAlertMessage(titl: "Error", msg:  (customError?.localizedDescription)!, displayTwoButtons: false)
                        return
                    }
                })
                
            })
        }

    }
    
    func btnFBLoginTap(_ sender: UIButton) {
        
        sender.convert(CGPoint.zero, to: self.tblLogin)
        
        self.btnFBLoginAction(sender:self)
        
    }
    
    //MARK:- Function
    
    func getFBUserDetails(handler : @escaping (_ userDict: [String: String])-> Void)
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    
                    // let UserFacebookDict = result as! NSDictionary
                    
                    guard let userInfo = result as? [String: Any] else { return }
                    
                    print(userInfo)
                    var fbUser = UserDetails()
                    var userDict = [String: String]()
                    
                    let strfirstName : String! = userInfo["first_name"] as? String
                    let strlastName : String! = userInfo["last_name"] as? String
                    
                    if let strFbId = (userInfo["id"] as? String){
                        fbUser.fbId = strFbId
                    }
                    else{
                        fbUser.fbId = ""
                    }
                    
                    if let strEmail = (userInfo["last_name"] as? String){
                        fbUser.email = strEmail
                    }
                    else{
                        fbUser.email = ""
                    }
                    
                    
                    if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        fbUser.picUrl = imageURL
                    }
                    else{
                        
                        fbUser.picUrl = ""
                    }
                    
                    fbUser.fullName = strfirstName + strlastName
                    
                    userDict["fullName"] = fbUser.fullName!
                    userDict["email"] = fbUser.email!
                    userDict["imageURL"] = fbUser.picUrl!
                    userDict["facebookID"] = fbUser.fbId!
                    
                    return handler(userDict)
                }
            })
        }
        
    }

    
    func getImageFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func deviceOrientationIsLandscape() -> Bool {
        
        let size: CGSize = UIScreen.main.bounds.size
        if (size.width / size.height > 1) {
            print("landscape")
            
            return true
            
        } else {
            print("portrait")
            
            return false
        }
    }

    
    // MARK: - Textfield Delegates
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if deviceOrientationIsLandscape() {
            
            if(textField.tag == 0){
                
                if let email = textField.text?.trim() {
                    
                    strUserName = email
                    
                    if (strUserName.characters.count > 0)
                    {
                        arrPlaceHolderValues.remove(at: textField.tag)
                        arrPlaceHolderValues.insert(strUserName, at: textField.tag)
                    }
                    else
                    {
                        arrPlaceHolderValues.remove(at: textField.tag)
                        arrPlaceHolderValues.insert("E-mail", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strUserName = ""
                    arrPlaceHolderValues.remove(at: textField.tag)
                    arrPlaceHolderValues.insert("E-mail", at: textField.tag)
                }
                
            }
                
            else{
                
                if let psswd = textField.text?.trim() {
                    
                    strPassword = psswd
                    
                    if (strPassword.characters.count > 0)
                    {
                        arrPlaceHolderValues.remove(at: textField.tag)
                        arrPlaceHolderValues.insert(strPassword, at: textField.tag)
                    }
                    else
                    {
                        arrPlaceHolderValues.remove(at: textField.tag)
                        arrPlaceHolderValues.insert("Password", at: textField.tag)
                    }
                    
                }
                else{
                    
                    strPassword = ""
                    arrPlaceHolderValues.remove(at: textField.tag)
                    arrPlaceHolderValues.insert("Password", at: textField.tag)
                }
            }
        }
        
        else{
            
            if (textField == txtUserName) {
                
                strUserName = (textField.text?.trim())!
                
                if let userName = textField.text?.trim() {
                    
                    strUserName = userName
                }
                else{
                    
                    strUserName = ""
                }
                
            }
            else{
                
                strPassword = (textField.text?.trim())!
                
                if let psswd = textField.text?.trim() {
                    
                    strPassword = psswd
                }
                else{
                    
                    strPassword = ""
                }
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:-
    
    func alert() -> Bool {
        
        if (strUserName.characters.count == 0) {
            
            showAlertMessage(titl: "", msg: "Please enter email", displayTwoButtons: false)
            return false
        }
        
        if (validateEmail(strUserName) == false) {
            
            showAlertMessage(titl: "", msg: "Please enter valid email", displayTwoButtons: false)
            return false
        }
        
        if (strPassword.characters.count == 0) {
            
            showAlertMessage(titl: "", msg: "Please enter password", displayTwoButtons: false)
            return false
        }
        
        if (strPassword.characters.count <= 6) {
            
            showAlertMessage(titl: "", msg: "Pasword length must be greater than 6 characters and must contain atleast \n1.one Uppercase character\n2.one Lowercase character\n3.one Special character", displayTwoButtons: false)
            return false
        }
        
        if (checkTextSufficientComplexity(text: strPassword) == false) {
            
            showAlertMessage(titl: "", msg: "Pasword must contain atleast \n1.one Uppercase character\n2.one Lowercase character\n3.one Special character", displayTwoButtons: false)
            return false
        }
        
        return true
    }
    
    // MARK:- UITableview Delegates and DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == 1 {
            return 75.0;
        }
        else{
            
            return 290.0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrPlaceHolderValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 1 {
            let cell:LoginTableViewCell = self.tblLogin.dequeueReusableCell(withIdentifier: "cell1") as! LoginTableViewCell!
            cell.txtCell1.delegate = self
            cell.txtCell1.tag = indexPath.row
            cell.txtCell1 .setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            cell.txtCell1.placeholder = arrPlaceHolderValues[indexPath.row]
            cell.imgVwIcon.image = UIImage(named: arrIcons[indexPath.row])
            
            cell.txtCell1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            if indexPath.row == 0 {
                cell.txtCell1.keyboardType = UIKeyboardType.emailAddress
                cell.txtCell1.isSecureTextEntry = false
                cell.imgVwForgotPassIcon.isHidden = true
            }
            else{
                
                cell.imgVwForgotPassIcon.isHidden = false
                cell.txtCell1.isSecureTextEntry = true
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        else{
            let cell:LoginTableViewCell = self.tblLogin.dequeueReusableCell(withIdentifier: "cell2") as! LoginTableViewCell!
            
            cell.btnLogin .addTarget(self, action: #selector(btnLoginTap(_:)), for: .touchUpInside)
            cell.btnFbLogin .addTarget(self, action: #selector(btnFBLoginTap(_:)), for: .touchUpInside)
            cell.btnSignUp .addTarget(self, action: #selector(btnRegisterTap(_:)), for: .touchUpInside)
            
             cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    
    
      // MARK:- Structure
    
    struct UserDetails {
        var fullName : String?
        var email : String?
        var picUrl : String?
        var fbId : String?
        
    }
    
    // MARK:-
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }

    
}


