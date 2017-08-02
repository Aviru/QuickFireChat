//
//  SyncManager.h
//  Snofolio_Instructor
//
//  Created by appsbee on 11/01/17.
//  Copyright © 2017 appsbee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;
@property(strong,nonatomic)AppDelegate *appDel;

//-(void)callWebServiceForSyncing;


#pragma mark -
#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;

@end
