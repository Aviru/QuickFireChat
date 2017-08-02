//
//  SignUpVC.m
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 16/07/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "SignUpVC.h"
#import "UserListVC.h"
#import "SignUpService.h"

@interface SignUpVC ()
{
    BOOL isValidPassword,isValidEmail,whiteSpaceChracter;
    NSString *password;
    QBUUser *user;
}

@end


@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_txtSignupUserName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtSignupPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtSignupEmail addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _txtSignupUserName)
    {
        if(textField.text.length > 0)
        {
            
        }
        
        else
        {
            _txtSignupUserName.text = @"";
        }
    }
    
    if (textField==_txtSignupEmail) //***Email
    {
        if(textField.text.length > 0)
        {
            isValidEmail = [self validateEmail:textField.text];
        }
        
        else
        {
            isValidEmail = NO;
        }
    }
    if (textField==_txtSignupPassword) //***Password
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
        
        if ([textField.text length]>0)
        {
            
            if([textField.text length] >= 6)
            {
                whiteSpaceChracter = NO;
                
                for (int i = 0; i < [_txtSignupPassword.text length]; i++)
                {
                    unichar c = [_txtSignupPassword.text characterAtIndex:i];
                    if(!whiteSpaceChracter)
                    {
                        whiteSpaceChracter = [whitespace characterIsMember:c];
                    }
                }
                
                if (whiteSpaceChracter)
                {
                    isValidPassword = NO;
                    
                }
                
                else
                {
                    password = _txtSignupPassword.text;
                    isValidPassword = YES;
                }
                
            }
            else
                isValidPassword = NO;
        }
        else
            isValidPassword=NO;
    }
    
}
#pragma mark

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)signUpAction:(id)sender
{
    if (isValidPassword == NO && isValidEmail == NO && [_txtSignupUserName.text isEqual: @""])
    {
        [self showAlertMessage:@"Alert!" :@"Please Enter all details" displayTwoButtons:NO];
    }
    else if ([_txtSignupUserName.text isEqualToString:@""])
    {
       [self showAlertMessage:@"Alert!" :@"Please enter valid user name" displayTwoButtons:NO];
    }
    else if (isValidEmail == NO)
    {
        [self showAlertMessage:@"Alert!" :@"Please ensure that you have entered correct Email" displayTwoButtons:NO];
        
    }
    
    else if (isValidPassword == NO)
    {
        [self showAlertMessage:@"Alert!" :@"Please enter valid Password. The Password must contain atleast 6 characters and should not contain white space." displayTwoButtons:NO];
        
    }
    else
    {
        user = [QBUUser user];
        user.fullName = _txtSignupUserName.text;
        user.login = _txtSignupEmail.text;
        user.email = _txtSignupEmail.text;
        user.password = password;
        
        [self startActivity:self.view];
        
        [[SignUpService service]callQBSignUpServiceWithUserDetails:user success:^(id  _Nullable response, NSString * _Nullable strMsg)
        {
            if (response != nil)
            {
                 NSLog(@"*****Quickblox Response for Sign up****:%@",response);
            }
            else
            {
                NSLog(@"%@", strMsg);
                
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
                [alertController addAction:actionOK];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            }
        }
        
        failure:^(NSError * _Nullable error, NSString * _Nullable strMsg)
        {
           [self stopActivity:self.view];
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            [alertController addAction:actionOK];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }];
        
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *currentUser)
        {
            // Success, do something
            
            NSLog(@"*****Quickblox Response for Sign up****:%@ \n User:%@",response,currentUser);
            
            
            [QBRequest logInWithUserEmail:currentUser.email password:password successBlock:^(QBResponse *response, QBUUser *loggedinUser)
             {
                 // Success, do something
                 
                 NSLog(@"*****Quickblox Response for Sign in****:%@ \n User:%@",response,loggedinUser);
                 
                 [self setUserDefaultValue:[@(loggedinUser.ID) stringValue] ForKey:QUICKBLOXID];
                 [self setUserDefaultValue:loggedinUser.email ForKey:EMAIL];
                 [self setUserDefaultValue:loggedinUser.fullName ForKey:FULL_NAME];
                 
                 [self stopActivity:self.view];
                 
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 UserListVC *userListVc = (UserListVC *)[storyboard instantiateViewControllerWithIdentifier:@"UserListVC"];
                 
                 [self.navigationController pushViewController:userListVc animated:YES];
                 
             }
             errorBlock:^(QBResponse *response)
             {
                  [self stopActivity:self.view];
                 
                 // error handling
                 NSLog(@"error: %@", response.error);
             }];
            
        }
        errorBlock:^(QBResponse *response)
         {
             [self stopActivity:self.view];
             // error handling
             NSLog(@"error: %@", response.error);
             
             [self showAlertMessage:@"Error!" :[NSString stringWithFormat:@"%@",response.error] displayTwoButtons:NO];
         }];
    }
}
@end
