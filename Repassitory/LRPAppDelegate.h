//
//  LRPAppDelegate.h
//  Repassitory
//
//  Created by Lansdon Page on 1/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LRPLoginViewController;
@class LRPSplitViewController;
@class LRPAlertViewController;
@class LRPAlertView;

@interface LRPAppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UINavigationController *loginNavC;
@property (strong, nonatomic) LRPLoginViewController *loginVC;
@property (strong, nonatomic) LRPSplitViewController *splitVC;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LRPAlertViewController* alertControl;
@property (nonatomic) LRPAlertView* loginAlert;

- (void) loginSuccessfull;
- (void) doLogin;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)addAlert:(LRPAlertView*)alert;
@end
