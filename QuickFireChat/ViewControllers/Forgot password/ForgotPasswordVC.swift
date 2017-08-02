//
//  ForgotPasswordVC.swift
//  QuickFireChat
//
//  Created by appsbee on 19/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var txtEmail: UITextField!
    
    var strEmail = ""
    var isViewUp : Bool! = false
    var isLandscape : Bool! = false
    var progressHUD : ProgressHUD! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let size: CGSize = UIScreen.main.bounds.size
        if (size.width / size.height > 1) {
            isLandscape = true
        } else {
            isLandscape = false
        }
    }
    
    
    /*
     // MARK: - Keyboard Notification
    @objc func keyboardWillAppear() {
        //Do something here
    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
    }
    */

    
    // MARK: - Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if isLandscape == true {
            
            if (isViewUp == true) {
                
            }
            else{
                
                viewUp()
            }
        }
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if let email = textField.text?.trim() {
            strEmail = email
        }
        else{
            
            strEmail = ""
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
    
    
    //MARK:- IBAction
   
    @IBAction func btnSubmitEmailAction(_ sender: Any) {
        
        if alert() {
            
            self.view.endEditing(true)
            
            self.progressHUD = ProgressHUD(text: "Loading...")
            self.view.addSubview(self.progressHUD)
            
            Auth.auth().sendPasswordReset(withEmail: strEmail) { (error) in
               
                self.progressHUD.hide()
                
                if error != nil {
                    self.showAlertMessage(titl: "Error", msg:  (error?.localizedDescription)!, displayTwoButtons: false)
                    return
                }
                
                self.showAlertMessage(titl: "", msg:  "An link has been sent to your registered e-mail id to rest password", displayTwoButtons: false)
            }
        }
    }
    
    
    //MARK:- Function
    
    func alert() -> Bool {
        
        if (strEmail.characters.count == 0) {
            
            showAlertMessage(titl: "", msg: "Please enter email", displayTwoButtons: false)
            return false
        }
        
        if (validateEmail(strEmail) == false) {
            
            showAlertMessage(titl: "", msg: "Please enter valid email", displayTwoButtons: false)
            return false
        }
        return true
    }


    
    // MARK: -
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
