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
@class LRPScreenAdjust;

@interface LRPDetailViewController : UITableViewController <UISplitViewControllerDelegate> {
}

// This is the existing record being displayed
//@property (strong, nonatomic) LRPRecord* record;

// Editing/saving an existing record involves remove old record
@property (assign, nonatomic) BOOL editingExistingRecord;

@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UITextField* titleTextField;
@property (weak, nonatomic) IBOutlet UITextField* usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField* urlTextField;
@property (weak, nonatomic) IBOutlet UITextField* notesTextField;

@property (weak, nonatomic) IBOutlet UINavigationItem* navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* btnRecordVault;	// 
@property (weak, nonatomic) IBOutlet UIBarButtonItem* btnDelete;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* btnEdit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* btnNew;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* btnSave;

@property (nonatomic) LRPScreenAdjust* screenAdj;


-(IBAction) saveRecord:(id)sender;
-(IBAction) deleteRecord:(id)sender;

- (IBAction)textFieldDidExit:(UITextField *)textField;
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)textField;

- (void)configureView;


@end
