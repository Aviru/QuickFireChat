//
//  SignUpVC.swift
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 19/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpVC: BaseViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var txtUserName: UITextField!
    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var imgVwProfile: UIImageView!
    
    @IBOutlet var tblSignUp: UITableView!
    
    
    @IBOutlet var imgVwProfilePortraitWidthConstraintCollection: [NSLayoutConstraint]!
    
    var arrPlaceHolderValues: [String] = ["User Name","E-mail", "Password",""]
    var arrIcons: [String] = ["user_icon.png","mail.png", "password_icon.png",""]
    
    fileprivate var imagePicker = ImagePicker()
    
    var strPassword = "",strUserName = "",strEmail = ""
    var imgName : String!
    var imageDownloadedURL : String!
    var imgData : Data?
    var isLandscape : Bool! = false
    var prevProfileImg : UIImage!
    
    
    
    
    var progressHUD : ProgressHUD! = nil
    var isViewUp : Bool! = false
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        prevProfileImg = imgVwProfile.image
        
        txtUserName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if isDeviceOrientationLandscape() {
            print("Landscape")
            
            isLandscape = true
            
            imgVwProfile.layer.cornerRadius = imgVwProfile.frame.size.width/2  //UIScreen.main.bounds.size.width/2 * imgVwProfileLandscapeWidthConstraint.multiplier
            imgVwProfile.clipsToBounds = true
            
        } else {
            print("Portrait")
            
            isLandscape = false
            
            for imgVwProfileWidthConstarint in imgVwProfilePortraitWidthConstraintCollection {
                
                imgVwProfile.layer.cornerRadius = UIScreen.main.bounds.size.width/2 * imgVwProfileWidthConstarint.multiplier
                imgVwProfile.clipsToBounds = true
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tblSignUp.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if isLandscape == true {
            
            if (isViewUp == true) {
                
            }
            else{
                
                viewUp()
            }
        }
        else{
            
            if (textField.tag == 2) {
                
                if (isViewUp == true) {
                    
                }
                else{
                    
                    viewUp()
                }
                
            }
        }
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if (textField.tag == 0) {
            
            if let userName = textField.text?.trim() {
                
                strUserName = userName
                
                if (strUserName.characters.count > 0)
                {
                    arrPlaceHolderValues.remove(at: textField.tag)
                    arrPlaceHolderValues.insert(strUserName, at: textField.tag)
                }
                else
                {
                    arrPlaceHolderValues.remove(at: textField.tag)
                    arrPlaceHolderValues.insert("User Name", at: textField.tag)
                }
                
            }
            else{
                
                strUserName = ""
                arrPlaceHolderValues.remove(at: textField.tag)
                arrPlaceHolderValues.insert("User Name", at: textField.tag)
            }
            
        }
        else if(textField.tag == 1){
            
            
            if let email = textField.text?.trim() {
                
                strEmail = email
                
                if (strEmail.characters.count > 0)
                {
                    arrPlaceHolderValues.remove(at: textField.tag)
                    arrPlaceHolderValues.insert(strEmail, at: textField.tag)
                }
                else
                {
                    arrPlaceHolderValues.remove(at: textField.tag)
                    arrPlaceHolderValues.insert("E-mail", at: textField.tag)
                }

            }
            else{
                
                strEmail = ""
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (isViewUp == true) {
            
            viewDown()
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func viewUp() {
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: -100, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                self.isViewUp = true
            }
        }
        
        else {
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: -80, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                self.isViewUp = true
            }
        }
        
    }
    
    func viewDown() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            self.isViewUp = false
        }
        
    }
    
    // MARK:- UITableview Delegates and DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return 60.0;
        }
        else{
            
            return 70.0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrPlaceHolderValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
            let cell:SignUpTableViewCell = tblSignUp.dequeueReusableCell(withIdentifier: "cell1") as! SignUpTableViewCell!
            cell.txtCell1.delegate = self
            cell.txtCell1.tag = indexPath.row
            cell.txtCell1 .setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            cell.txtCell1.placeholder = arrPlaceHolderValues[indexPath.row]
            cell.txtCell1.autocorrectionType = .no
            cell.imgVwIcon.image = UIImage(named: arrIcons[indexPath.row])
            
            cell.txtCell1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            if indexPath.row == 0 {
                cell.txtCell1.autocapitalizationType = .words
                cell.txtCell1.isSecureTextEntry = false
            }
            
            if indexPath.row == 1 {
                cell.txtCell1.keyboardType = UIKeyboardType.emailAddress
                cell.txtCell1.isSecureTextEntry = false
            }
            else if indexPath.row == 2{
                
                cell.txtCell1.isSecureTextEntry = true
            }
            
             cell.selectionStyle = .none
            
            return cell
        }
        else{
            let cell:SignUpTableViewCell = tblSignUp.dequeueReusableCell(withIdentifier: "cell2") as! SignUpTableViewCell!
            
            cell.btnSignUp .addTarget(self, action: #selector(btnSignUpTap(_:)), for: .touchUpInside)
            
             cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    
    //MARK:- Button Action
    
    func btnSignUpTap(_ sender: UIButton) {
        
        sender.convert(CGPoint.zero, to: self.tblSignUp)
        
        if alert() {
            
            self.progressHUD = ProgressHUD(text: "Loading...")
            self.view.addSubview(self.progressHUD)
            
            FirebaseUserSystem.system.createAccount(email: strEmail, password: strPassword, completion: { (user, success, error) in
                
                if error != nil {
                    
                    self.progressHUD.hide()
                    self.showAlertMessage(titl: "Error", msg: (error?.localizedDescription)!, displayTwoButtons: false)
                    return
                }
                
                let firUser : User = user!
                
                FirebaseUserSystem.system.saveImageToFirebase(userProfileImage: self.imgVwProfile.image,imageName:self.imgName,imageData: self.imgData , user: firUser, handler: { (uploadedImgURL, isImageSaved,customError) in
                    
                    if isImageSaved == true {
                        
                        self.imageDownloadedURL = uploadedImgURL
                        
                        FirebaseUserSystem.system.saveUserToFirebaseDB(userName: self.strUserName, imageDownloadedURL: self.imageDownloadedURL, user: firUser, handler: { (dataSavedStatus,error) in
                            
                            if dataSavedStatus == true{
                                
                                FirebaseUserSystem.system.loginAccount(email: self.strEmail, password: self.strPassword, completion: { (user, signInStatus, error) in
                                    
                                    self.progressHUD.hide()
                                    
                                    if error != nil {
                                        
                                        self.progressHUD.hide()
                                        self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                                        return
                                    }
                                    // User is signed in
                                    // ...
                                    
                                    if GlobalUserDefaults.saveObject(obj: "YES" as AnyObject, key: "IsLoggedIn") {
                                        
                                        print("LoggedIn status saved to UserDefaults")
                                    }
                                    else{
                                        
                                        print("unable to LoggedIn status save UserDefaults")
                                    }
                                    
                                    self.performSegue(withIdentifier: "showUserListFromSignUp", sender: nil)
                                    
                                })
                                
                            }
                            else{
                                
                                self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                                return
                                
                            }
                            
                        })
                    }
                    else {
                        
                        self.progressHUD.hide()
                        self.showAlertMessage(titl: "Error", msg:  (customError?.localizedDescription)!, displayTwoButtons: false)
                        
                        return
                    }
                })

            })
            
        }
        
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        
        
    }
    
    @IBAction func btnEditPictureAction(_ sender: Any) {
        
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let cameraActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            print("camera")
            
            self.imagePicker.cameraAsscessRequest()
        }
        actionSheetController.addAction(cameraActionButton)
        
        let GalleryActionButton = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            print("Gallery")
            
            self.imagePicker.galleryAsscessRequest()
        }
        actionSheetController.addAction(GalleryActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    //MARK:- Function
    
    fileprivate func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.controller.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePicker.controller, animated: true, completion: nil)
        }
    }
    
    func alert() -> Bool {
        
        if (strEmail.characters.count == 0) {
            
            showAlertMessage(titl: "", msg: "Please enter email", displayTwoButtons: false)
            return false
        }
        
        if (validateEmail(strEmail) == false) {
            
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
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}


extension SignUpVC: ImagePickerDelegate {
    
    func imagePickerDelegate(didSelect image: UIImage, imageName:String, delegatedForm: ImagePicker) {
        imgVwProfile.image = image
        imgData = UIImagePNGRepresentation(image)
        imgName = String(format: "%@.png", imageName)
        imagePicker.dismiss()
    }
    
    func imagePickerDelegate(didCancel delegatedForm: ImagePicker) {
        imagePicker.dismiss()
    }
    
    func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed {
            presentImagePicker(sourceType: .photoLibrary)
        }
    }
    
    func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed {
            // works only on real device (crash on simulator)
            presentImagePicker(sourceType: .camera)
        }
        else{
            
              showAlertMessage(titl: "", msg: "Camera not available", displayTwoButtons: false)
        }
    }
}
