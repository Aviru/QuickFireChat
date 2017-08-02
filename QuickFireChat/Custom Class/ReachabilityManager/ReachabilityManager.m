//
//  SyncManager.m
//  Snofolio_Instructor
//
//  Created by appsbee on 11/01/17.
//  Copyright © 2017 appsbee. All rights reserved.
//

#import "ReachabilityManager.h"

@interface ReachabilityManager ()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation ReachabilityManager

@synthesize appDel;

#pragma mark -
#pragma mark Default Manager
+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        
        appDel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
        
    }
    
    return self;
}



#pragma mark
#pragma mark reachability helping methods
#pragma mark

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];

}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.internetReachability)
    {
        appDel.isRechable= [reachability connectionRequired];
    }
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            appDel.isRechable = NO;
            NSLog(@"Internet not rechable");
            break;
        }
        case ReachableViaWWAN:
        {
            appDel.isRechable=YES;
            NSLog(@"Internet rechable via WAN");
            break;
        }
        case ReachableViaWiFi:
        {
            appDel.isRechable=YES;
            NSLog(@"Internet rechable via WIFI");
            break;
        }
    }
}



#pragma mark
#pragma mark Memory Management
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.hostReachability stopNotifier];
    [self.internetReachability stopNotifier];
}

@end
