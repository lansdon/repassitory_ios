//
//  LRPSplitViewController.h
//  Repassitory
//
//  Created by Lansdon Page on 1/20/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRPUser;
@class LRPLoginViewController;
@class LRPDetailViewController;
@class LRPMasterViewController;
@class LRPAddRecordViewController;

@interface LRPSplitViewController : UISplitViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) LRPLoginViewController *loginVC;
@property (strong, nonatomic) LRPDetailViewController *detailVC;
@property (strong, nonatomic) LRPMasterViewController *masterVC;
@property (strong, nonatomic) LRPAddRecordViewController *addVC;

 @property (strong, nonatomic) LRPUser *user;


@end
