//
//  UserListVC.m
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 26/07/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "UserListVC.h"
#import "UserListCell.h"

@interface UserListVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UserListCell *cell;
    int userNumber;
}

@end

@implementation UserListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.paginator = [[UsersPaginator alloc] initWithPageSize:10 delegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak typeof(self)weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [weakSelf setupTableViewFooter];
        [weakSelf.paginator fetchFirstPage];
    });
}


- (void)setupTableViewFooter
{
    // set up label
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [footerView addSubview:label];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(40, 22);
    activityIndicatorView.hidesWhenStopped = YES;
    
    self.activityIndicator = activityIndicatorView;
    [footerView addSubview:activityIndicatorView];
    
    self.userListTableVw.tableFooterView = footerView;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height){
        // ask next page only if we haven't reached last page
        if(![self.paginator reachedLastPage]){
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}


#pragma mark - Table view data source And Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.arrUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UserCell";
    
    if (cell == nil)
    {
        cell = (UserListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.lblUserName.text = [_arrUserName objectAtIndex:indexPath.row];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark

#pragma mark Paginator

- (void)fetchNextPage
{
    [self.paginator fetchNextPage];
    [self.activityIndicator startAnimating];
}

#pragma mark

#pragma mark NMPaginatorDelegate

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    [_arrUsers addObjectsFromArray:results];
    
    // update tableview footer
    //[self updateTableViewFooter];
    
    [self.activityIndicator stopAnimating];
    // reload table
    [self.userListTableVw reloadData];
}


- (void)retrieveAllUsersFromPage:(int)page{
    
    [QBRequest usersForPage:[QBGeneralResponsePage responsePageWithCurrentPage:page perPage:100] successBlock:^(QBResponse *response, QBGeneralResponsePage *pageInformation, NSArray *users) {
        userNumber += users.count;
        if (pageInformation.totalEntries > userNumber) {
            [self retrieveAllUsersFromPage:page + 1];
        }
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];
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

#pragma mark
#pragma mark - Button Action
#pragma mark

- (IBAction)editProfileAction:(id)sender {
    
    [self setImageFromCamera];
}

- (IBAction)ImageCaptureAction:(id)sender {
}

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
    [picker setVideoMaximumDuration:60.0f]; //120.0f
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

#pragma mark Image Picker Delegate Method

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

@end
