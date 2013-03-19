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
@class MBAlertView;
@class LRPDetailViewController;
@class LRPMasterViewController;
@class Record;

@interface LRPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *loginNavC;
@property (strong, nonatomic) LRPLoginViewController *loginVC;

@property (strong, nonatomic) LRPSplitViewController *splitVC;				// ipad post login starting point
@property (strong, nonatomic) UINavigationController *phoneRecordsNav;		// iphone post login starting point

@property (strong, nonatomic) LRPDetailViewController *detailVC;
@property (strong, nonatomic) LRPMasterViewController *masterVC;


@property (nonatomic) bool mastervc_loaded;
@property (nonatomic) bool splitvc_loaded;
@property (nonatomic) bool detailvc_loaded;

@property Record* currentRecord;

- (id)registerViewController:(id)viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) openRecords;
- (void)setUserLoginComplete:(bool)isLoggedIn;


@end
