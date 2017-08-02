//
//  ModelUserInfo.m
//  QuickChatDemo
//
//  Created by Aviru bhattacharjee on 03/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

#import "ModelUserInfo.h"

@implementation ModelUserInfo

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:QUICKBLOXID] && ![[dict objectForKey:QUICKBLOXID] isKindOfClass:[NSNull class]])
        {
            self.strUserId=[dict objectForKey:QUICKBLOXID];
        }
        else
        {
            self.strUserId=@"";
        }
        
        if ([dict objectForKey:FACEBOOK_ID] && ![[dict objectForKey:FACEBOOK_ID] isKindOfClass:[NSNull class]])
        {
            self.strUserFacebookId=[dict objectForKey:FACEBOOK_ID];
        }
        else
        {
            self.strUserFacebookId=@"";
        }
        
        if ([dict objectForKey:FULL_NAME] && ![[dict objectForKey:FULL_NAME] isKindOfClass:[NSNull class]])
        {
            self.strUserName=[dict objectForKey:FULL_NAME];
        }
        else
        {
            self.strUserName=@"";
        }
        
        
        if ([dict objectForKey:EMAIL] && ![[dict objectForKey:EMAIL] isKindOfClass:[NSNull class]])
        {
            self.strUserEmail=[dict objectForKey:EMAIL];
        }
        else
        {
            self.strUserEmail=@"";
        }
        
        
        if ([dict objectForKey:@"dob"] && ![[dict objectForKey:@"dob"] isKindOfClass:[NSNull class]])
        {
            self.strUserDob=[dict objectForKey:@"dob"];
        }
        else
        {
            self.strUserDob=@"";
        }
        
        
        if ([dict objectForKey:@"country"] && ![[dict objectForKey:@"country"] isKindOfClass:[NSNull class]])
        {
            self.strUserCountry=[dict objectForKey:@"country"];
        }
        else
        {
            self.strUserCountry=@"";
        }
        
        
        if ([dict objectForKey:@"image_url"] && ![[dict objectForKey:@"image_url"] isKindOfClass:[NSNull class]])
        {
            self.strUserProfileImageUrl=[dict objectForKey:@"image_url"];
        }
        else
        {
            self.strUserProfileImageUrl=@"";
        }

        
    }
    return self;
}


@end
