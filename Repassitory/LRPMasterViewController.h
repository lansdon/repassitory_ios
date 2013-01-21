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

@interface LRPMasterViewController : UITableViewController

//@property (strong, nonatomic) LRPDetailViewController *detailViewController;

@property (strong, nonatomic) LRPRecordDataController* dataController;

@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) LRPSplitViewController *splitVC;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end