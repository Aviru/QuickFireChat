//
//  UserListCell.h
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 26/07/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImgVw;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UILabel *lblTypingStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblLastMsgDate;

@property (weak, nonatomic) IBOutlet UILabel *lblUnreadMsgCount;

@end
