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


@interface LRPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) LRPLoginViewController *loginVC;
@property (strong, nonatomic) LRPSplitViewController *splitVC;

@property (strong, nonatomic) UIWindow *window;


- (void) loginSuccessfuil;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
