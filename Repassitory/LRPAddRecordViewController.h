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
@property (weak, nonatomic) IBOutlet UITextField *notesInput;

@property (strong, nonatomic) LRPRecord* record;

@property (weak, nonatomic) LRPSplitViewController *splitVC;

// Text field movement when keyboard is blocking
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)textField;
- (void) animateTextField: (UITextField*) textField up: (BOOL) up;

@end
