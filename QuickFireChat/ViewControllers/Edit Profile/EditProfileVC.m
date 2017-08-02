//
//  EditProfileVC.m
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 03/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

#import "EditProfileVC.h"
#import "EditProfileTableViewCell.h"
#import "ModelUserInfo.h"

@interface EditProfileVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UITableView *tblEditProfile;
    
    IBOutlet UIImageView *imgVwUser;
    
    UITextField *globalTextField;
    UIDatePicker *datePickerView;
    UIToolbar *toolBar;
    NSMutableArray *arrValuesAndPlaceHolder;
    NSArray *arrCellIcon;
    UIImage *profileImage;
    NSString *strCountry, *strFullName, *strDob, *strState, *strCity, *strBio;
    BOOL isViewUp;
    
    EditProfileTableViewCell *editProfileCell;
}

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imgVwUser.layer.cornerRadius = [[UIScreen mainScreen]bounds].size.width/2 * .45;
    
    imgVwUser.clipsToBounds = YES;
    
     arrValuesAndPlaceHolder = [[NSMutableArray alloc]initWithObjects:@"Your Name",@"Phone",@"Date of birth",@"Country",@"City",@"Bio", nil];
    
     arrCellIcon = [[NSArray alloc]initWithObjects:@"user_icon.png",@"phone_icon.png",@"calender_icon.png",@"location_icon.png",@"location_icon.png",@"bio_icon.png", nil];
    
    datePickerView=[[UIDatePicker alloc] init];
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePickerView.maximumDate = [NSDate date];
    [datePickerView setDatePickerMode:UIDatePickerModeDate];
    [datePickerView addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(pressedDone:)];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          datePickerView.frame.size.height-70, self.view.frame.size.width, 36)];
    [toolBar setBarStyle:UIBarStyleDefault];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton,nil];
    [toolBar setItems:toolbarItems];
    
    strFullName = @"";
    strDob = @"";
    strCountry = @"";
    strState = @"";
    strCity = @"";
    strBio = @"";
}

#pragma mark
#pragma mark Tableview delegates and Datasource
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrValuesAndPlaceHolder.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6)
    {
        if (editProfileCell == nil)
        {
            editProfileCell = (EditProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        }
        
        editProfileCell.txtVwCell2.tag = indexPath.row;
        editProfileCell.txtVwCell2.delegate = self;
        editProfileCell.txtVwCell2.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
         editProfileCell.imgVwIconCell2.image = [UIImage imageNamed:arrCellIcon[indexPath.row]];
    }
    else
    {
        if (editProfileCell == nil)
        {
            editProfileCell = (EditProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        }
        
        editProfileCell.txtCell1.tag = indexPath.row;
        editProfileCell.txtCell1.delegate = self;
        editProfileCell.txtCell1.autocorrectionType = UITextAutocorrectionTypeNo;
        editProfileCell.txtCell1.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [ editProfileCell.txtCell1 addTarget:self
                                      action:@selector(textFieldDidChange:)
                            forControlEvents:UIControlEventEditingChanged];
        
        editProfileCell.txtCell1.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        editProfileCell.imgVwIconCell1.image = [UIImage imageNamed:arrCellIcon[indexPath.row]];
    }
    
    return editProfileCell;
}

#pragma mark
#pragma mark - textfield delegate
#pragma mark

-(void)textFieldDidChange:(UITextField *)theTextField
{
    if (theTextField.tag==0)
    {
        strFullName=[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (strFullName.length > 0)
        {
            [arrValuesAndPlaceHolder removeObjectAtIndex:theTextField.tag];
            [arrValuesAndPlaceHolder insertObject:strFullName atIndex:theTextField.tag];
        }
        else
        {
            [arrValuesAndPlaceHolder removeObjectAtIndex:theTextField.tag];
           // [arrValuesAndPlaceHolder insertObject:strUserName atIndex:theTextField.tag];
            //strFullName = objModeluser.strUserName;
        }
        
    }
    NSLog(@"PlaceHolder Array:%@",arrValuesAndPlaceHolder);
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    globalTextField = textField;
    
    if (globalTextField.tag == 2)
    {
        
        if (isViewUp) {
            
        }
        else
            [self viewUp];
        
        
        globalTextField.inputView = datePickerView;
        globalTextField.inputAccessoryView = toolBar;
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (isViewUp)
    {
        [self viewDown];
    }
    
    [textField resignFirstResponder];
    return YES;
}
-(void)viewUp
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(self.view.frame.origin.x,-80, self.view.frame.size.width, self.view.frame.size.height);
        isViewUp=YES;
    }];
}

-(void)viewDown
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        isViewUp=NO;
    }];
}

#pragma mark-
#pragma mark - date picker change value not required right now
#pragma mark-

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSLog(@"DateSelect=%@",[datePicker date]);
    
}

#pragma mark-
#pragma set mark - dateformater
#pragma mark-

-(NSString*)timeformatSet:(NSDate*)date1
{
    NSString *strDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"Current Date: %@", [formatter stringFromDate:date1]);
    strDate=[formatter stringFromDate:date1];
    return strDate;
}

#pragma mark
#pragma mark- Toolbar Button Action
#pragma mark

-(void)pressedDone:(id)sender
{
    [self.view endEditing:YES];
    strDob = [self timeformatSet:[datePickerView date]];
    
    [arrValuesAndPlaceHolder removeObjectAtIndex:globalTextField.tag];
    [arrValuesAndPlaceHolder insertObject:strDob atIndex:globalTextField.tag];
    
    globalTextField.text = strDob;
    
    if (isViewUp)
    {
        [self viewDown];
    }
}

#pragma mark
#pragma mark - Button Action
#pragma mark

- (IBAction)btnEditPicture:(id)sender {
    
    
}

- (IBAction)btnEditProfile:(id)sender {
    
    [self setImageFromCamera];
}

- (IBAction)btnChangePassword:(id)sender {
}

#pragma mark

#pragma mark
#pragma mark For Taking Image From Camera & Gallary
#pragma mark

- (void)setImageFromCamera{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Select Option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  [self funImageFromGalary];
                              }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  [self funImageFromPhoneCamera];
                                  
                              }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  
                                  
                              }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)funImageFromGalary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)funImageFromPhoneCamera{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        // show camera
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        // don't show camera
        [self showAlertMessage:@"Alert!" :@"Please select from gallery" displayTwoButtons:NO];
    }
}

#pragma mark
#pragma mark Image Picker Delegate Method
#pragma mark

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgChosen=info[UIImagePickerControllerOriginalImage] ;
    
    NSData *imgData = UIImageJPEGRepresentation(imgChosen, 0.5);
    
    [QBRequest TUploadFile:imgData fileName:@"myAvatar.png" contentType:@"image/png" isPublic:YES successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nonnull blob) {
        
        NSLog(@"Response after Image is uploaded:%@",response);
        
        QBUpdateUserParameters *userParams = [QBUpdateUserParameters new];
        userParams.blobID = blob.ID;
        
        [QBRequest updateCurrentUser:userParams successBlock:^(QBResponse * _Nonnull __unused response, QBUUser * _Nullable user) {
        } errorBlock:^(QBResponse * _Nonnull response) {
            
            if (!response.error)
            {
                NSLog(@"Response after blobId Id is successfully updated:%@",response);
            }
            else
            {
                NSLog(@"Error in uploading blobId Id:%@",response);
            }
            
        }];
        
    } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        
        NSLog(@"Error:%@",response.error);
    }];
}

#pragma mark

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

@end
