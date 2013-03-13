//
//  LRPMasterViewController.h
//  SplitTest
//
//  Created by Lansdon Page on 1/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRPRecordDataController;
@class LRPDetailViewController;
@class LRPSplitViewController;
@class LRPRecord;
@class LRPAlertView;

@interface LRPMasterViewController : UITableViewController {

}

@property (strong, nonatomic) LRPRecordDataController* dataController;
@property (strong, nonatomic) LRPDetailViewController *detailViewController;
@property (weak, nonatomic) LRPSplitViewController *splitVC;
@property (nonatomic) LRPAlertView* activityAlert;

//- (void) loadUserRecords;

- (void) tableViewBeginUpdates;
- (void) reloadData;

@end
