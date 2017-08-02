//
//  ForgotPasswordVC.h
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 26/07/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordVC : BaseVC<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtForgotPassEmail;


- (IBAction)submitEmailAction:(id)sender;

- (IBAction)backToLoginAction:(id)sender;

@end
