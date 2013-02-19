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


@interface LRPDetailViewController : UITableViewController <UISplitViewControllerDelegate> {
	
	UILabel* segmentedLabel;
	UISegmentedControl* segmentedControl;

	// MUST match seg control layout!!
	enum BTN_TYPE { BTN_DELETE, BTN_EDIT, BTN_NEW, BTN_SAVE };
	
	// current mode of detail screen
	enum STATE { STATE_BLANK, STATE_DISPLAY, STATE_EDIT, STATE_CREATE };
	int currentState;
}

@property (strong, nonatomic) LRPRecord* record;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (retain, nonatomic) IBOutlet UITextField* titleTextField;
@property (retain, nonatomic) IBOutlet UITextField* usernameTextField;
@property (retain, nonatomic) IBOutlet UITextField* passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField* urlTextField;
@property (retain, nonatomic) IBOutlet UITextField* notesTextField;

@property (weak, nonatomic) IBOutlet UINavigationItem* navBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* btnDelete;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* btnEdit;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* btnNew;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* btnSave;

@property (weak, nonatomic) LRPSplitViewController *splitVC;

-(IBAction) segmentedControlIndexChanged;
-(IBAction) saveRecord:(id)sender;
-(IBAction) deleteRecord:(id)sender;

- (IBAction)textFieldDidExit:(UITextField *)textField;
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)textField;

@end
