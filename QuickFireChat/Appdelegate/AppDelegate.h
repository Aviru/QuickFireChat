//
//  AppDelegate.h
//  QuickFireChat
//
//  Created by Aviru bhattacharjee on 18/06/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@class ModelUserInfo;

@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property(assign,nonatomic) BOOL isRechable;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic)ModelUserInfo *objModelUserInfo;

@end
