//
//  LRPAddRecordViewController.h
//  SplitTest
//
//  Created by Lansdon Page on 1/14/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRPRecord;
@class LRPSplitViewController;

@interface LRPAddRecordViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *urlInput;

@property (strong, nonatomic) LRPRecord* record;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) LRPSplitViewController *splitVC;

@end
