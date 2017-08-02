//
//  ModelUserInfo.h
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 03/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelUserInfo : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strUserId;
@property(nonatomic,strong)NSString *strUserFacebookId;
@property(nonatomic,strong)NSString *strUserName;
@property(nonatomic,strong)NSString *strUserEmail;
@property(nonatomic,strong)NSString *strUserDob;
@property(nonatomic,strong)NSString *strUserCountry;
@property(nonatomic,strong)NSString *strUserProfileImageUrl;


@end
