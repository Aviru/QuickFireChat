//
//  SignUpVC.h
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 16/07/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedButton.h"

@interface SignUpVC : BaseVC<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtSignupUserName;

@property (weak, nonatomic) IBOutlet UITextField *txtSignupEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtSignupPassword;

@property (strong, nonatomic) IBOutlet RoundedButton *signUpBtnOutlet;


- (IBAction)signUpAction:(id)sender;

@end
