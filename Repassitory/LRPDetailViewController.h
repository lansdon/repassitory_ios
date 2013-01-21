//
//  LRPDetailViewController.h
//  SplitTest
//
//  Created by Lansdon Page on 1/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRPRecord;
@class LRPSplitViewController;


@interface LRPDetailViewController : UITableViewController <UISplitViewControllerDelegate>

//@property (strong, nonatomic) id detailItem;

//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) LRPRecord* record;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel* passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel* urlLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) LRPSplitViewController *splitVC;

@end
