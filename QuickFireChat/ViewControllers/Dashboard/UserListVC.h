//
//  UserListVC.h
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 26/07/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListVC : BaseVC<UITableViewDelegate,UITableViewDataSource,NMPaginatorDelegate>


@property (weak, nonatomic) IBOutlet UITableView *userListTableVw;

@property(strong,nonatomic)NSMutableArray *arrUsers;
@property(strong,nonatomic)NSMutableArray *arrUserName;
@property(strong,nonatomic)NSMutableArray *arrUserEmail;
@property(strong,nonatomic)NSMutableArray *arrUserImg;
@property (nonatomic, strong) UsersPaginator *paginator;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

- (IBAction)editProfileAction:(id)sender;

- (IBAction)ImageCaptureAction:(id)sender;


@end
