//
//  ForgotPasswordVC.m
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 26/07/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()
{
    BOOL isValidEmail;
}

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField==_txtForgotPassEmail) //***Email
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitEmailAction:(id)sender
{
    if (isValidEmail == NO)
    {
         [self showAlertMessage:@"Alert!" :@"Please ensure that you have entered correct Email" displayTwoButtons:NO];
    }
    else
    {
        // Reset User's password with email
        [QBRequest resetUserPasswordWithEmail:_txtForgotPassEmail.text successBlock:^(QBResponse *response)
        {
            // Reset was successful
            
             [self showAlertMessage:@"Alert!" :@"Password Changed successfully" displayTwoButtons:NO];
        }
        errorBlock:^(QBResponse *response)
        {
            // Error
        }];
    }
}

- (IBAction)backToLoginAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
