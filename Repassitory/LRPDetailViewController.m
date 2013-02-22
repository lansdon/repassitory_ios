//
//  LRPDetailViewController.m
//  SplitTest
//
//  Created by Lansdon Page on 1/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPDetailViewController.h"

#import "LRPSplitViewController.h"
#import "LRPMasterViewController.h"
#import "LRPLoginViewController.h"
#import "LRPRecordDataController.h"
#import "LRPRecord.h"
#import "LRPUser.h"
#import "LRPAppState.h"

@interface LRPDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
//- (void)configureView;
//-(void) saveRecord;
//-(void) deleteRecord;

@end



@implementation LRPDetailViewController
@synthesize titleTextField, usernameTextField, passwordTextField, urlTextField, notesTextField, dateLabel;
@synthesize record;

#pragma mark - Managing the detail item

- (void)setRecord:(LRPRecord *)newRecord
{
    if (record != newRecord) {
        record = newRecord;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Current User Label
    if ( [LRPAppState checkForUser] ) {
        NSString* greeting = [[NSString alloc] initWithFormat:@"Welcome, %@", [LRPAppState currentUser].username];
		self.navigationItem.title = greeting;
    }
    
    // Update the user interface for the detail item.
    LRPRecord* theRecord = self.record;
    if (theRecord) {
		[self setState:STATE_DISPLAY];
    } else {
		[self setState:STATE_BLANK];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	if(!record) record = [LRPRecord alloc];
	self.editingExistingRecord = NO;
	
    [self configureView];

    self.splitVC = (LRPSplitViewController *)self.splitViewController;
    
    // register self with SplitVC
    self.splitVC.detailVC = self;
    
    // Test for user logged in
//    if ( [LRPAppState checkForUser] ) {
//    }
    
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor clearColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Record Vault", @"Record Vault");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self configureView];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DoLoginSegue"]) {
        // Set managed object on Split View
        LRPLoginViewController* loginVC = [segue destinationViewController];
        loginVC.splitVC = self.splitVC;
    }
}





#pragma mark - Toolbar (Buttons)

-(void) updateButtonStates {
	switch (currentState) {
		case STATE_BLANK:
			[self btnSetEnabled:NO forIndex:BTN_DELETE];
			[self btnSetEnabled:NO forIndex:BTN_EDIT];
			[self btnSetEnabled:YES forIndex:BTN_NEW];
			[self btnSetEnabled:NO forIndex:BTN_SAVE];
			break;
			
		case STATE_CREATE:
			[self btnSetEnabled:NO forIndex:BTN_DELETE];
			[self btnSetEnabled:NO forIndex:BTN_EDIT];
			[self btnSetEnabled:YES forIndex:BTN_NEW];
			[self btnSetEnabled:YES forIndex:BTN_SAVE];
			break;
			
		case STATE_DISPLAY:
			[self btnSetEnabled:YES forIndex:BTN_DELETE];
			[self btnSetEnabled:YES forIndex:BTN_EDIT];
			[self btnSetEnabled:YES forIndex:BTN_NEW];
			[self btnSetEnabled:NO forIndex:BTN_SAVE];
			break;
			
		case STATE_EDIT:
			[self btnSetEnabled:YES forIndex:BTN_DELETE];
			[self btnSetEnabled:NO forIndex:BTN_EDIT];
			[self btnSetEnabled:YES forIndex:BTN_NEW];
			[self btnSetEnabled:YES forIndex:BTN_SAVE];
			break;
			
		default:
			[self btnSetEnabled:NO forIndex:BTN_DELETE];
			[self btnSetEnabled:NO forIndex:BTN_EDIT];
			[self btnSetEnabled:NO forIndex:BTN_NEW];
			[self btnSetEnabled:NO forIndex:BTN_SAVE];
			break;
	}
}
-(void) btnSetEnabled:(bool)bEnabled forIndex:(int)index {
	//	[segmentedControl setEnabled:bEnabled forSegmentAtIndex:index];
	switch (index) {
		case BTN_DELETE: [self.btnDelete setEnabled:bEnabled]; break;
		case BTN_EDIT: [self.btnEdit setEnabled:bEnabled]; break;
		case BTN_NEW: [self.btnNew setEnabled:bEnabled]; break;
		case BTN_SAVE:[self.btnSave setEnabled:bEnabled]; break;
	}
}

#pragma mark - States

-(void) setState:(int)newState {
	currentState = newState;
	[self updatePageComponents];
}

-(void) updatePageComponents {
	switch (currentState) {
		case STATE_BLANK:
			[self setEditingExistingRecord:NO];
			[self disableInputFields];
			titleTextField.text = @"(Select/create a record)";
			self.usernameTextField.text = @"";
			self.passwordTextField.text = @"";
			self.urlTextField.text = @"";
			self.dateLabel.text = @"";
			self.notesTextField.text = @"";
			
			break;
			
		case STATE_CREATE:
			[self setEditingExistingRecord:NO];
			[self.record clear];
			titleTextField.text = @"";
			usernameTextField.text = @"";
			passwordTextField.text = @"";
			urlTextField.text = @"";
			dateLabel.text = @"";
			notesTextField.text = @"";
			[self enableInputFields];
			break;
			
		case STATE_DISPLAY:
			[self setEditingExistingRecord:NO];
			// Load current record to screen
			titleTextField.text = self.record.title;
			usernameTextField.text = self.record.username;
			passwordTextField.text = self.record.password;
			urlTextField.text = self.record.url;
			dateLabel.text = [self.record getUpdateAsString];
			notesTextField.text = self.record.notes;
//			[self.tableView reloadData];
			[self.tableView reloadData];
			
			[self disableInputFields];
			break;
			
		case STATE_EDIT:
			[self setEditingExistingRecord:YES];
			[self enableInputFields];
			break;
			
		default:
			
			break;
	}

	[self updateButtonStates];
	[self.tableView reloadData];
	
}

-(void) disableInputFields {
	[self setActiveCellByRow:-1];  // clear them all
	[titleTextField setEnabled:NO];
	[usernameTextField setEnabled:NO];
	[passwordTextField setEnabled:NO];
	[urlTextField setEnabled:NO];
	[notesTextField setEnabled:NO];	
}

-(void) enableInputFields {
	[self setActiveCellByRow:0];		// start with first cell
	[titleTextField setEnabled:YES];
	[usernameTextField setEnabled:YES];
	[passwordTextField setEnabled:YES];
	[urlTextField setEnabled:YES];
	[notesTextField setEnabled:YES];
}

// Indicate whichi cells are active
-(void)setActiveCellByRow:(int)row {
//	UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
	NSArray* indexPaths = [self.tableView visibleCells];
	for(int i=0; i<[indexPaths count]; ++i) {
		UITableViewCell* cell = indexPaths[i];
		if(row == i) {
			[cell setBackgroundColor:[UIColor redColor]];
			[self setFirstResponderByTableRow:row];
		} else {
			[cell setBackgroundColor:[UIColor clearColor]];
		}
	}
//	firstCell.selectionStyle = UITableViewCellSelectionStyleBlue;
//	[firstCell setSelected:YES animated:YES];
	
}

-(void)setFirstResponderByTableRow:(int)row {
	switch(row) {
		case 0: [self.titleTextField becomeFirstResponder]; break;
		case 1: [self.usernameTextField becomeFirstResponder]; break;
		case 2: [self.passwordTextField becomeFirstResponder]; break;
		case 3: [self.urlTextField becomeFirstResponder]; break;
		case 4: [self.notesTextField becomeFirstResponder]; break;
	}
}


#pragma mark - Database / Records
-(IBAction) saveRecord:(id)sender {
	[self doConfirmDialogueWithTitle:@"Save Record" message:@"Are you sure you want to save this record?"];
}

-(void)saveRecordConfirmed {
	// Need to remove old record?
	if(self.editingExistingRecord) {
		[self.splitVC.masterVC.dataController deleteRecord:record];
		[self.record clear];
	}
	
	// Store Record in Core Data using input fields
	if(!record) record = [LRPRecord alloc];
	self.record = [self.record initWithTitle:titleTextField.text
									username:usernameTextField.text
									password:passwordTextField.text
									url:urlTextField.text
									notes:notesTextField.text];
	
	
	[self.splitVC.masterVC.dataController addRecord:record];

	// Update Master View
	[self.splitVC.masterVC.tableView reloadData];
	
	// Update button states
	[self setState:STATE_DISPLAY];
	
	// Display Green Checkmark
//	[self.splitVC.masterVC displayCheckmark:record];
	
	UIBarButtonItem* masterButton = self.navBar.leftBarButtonItems[0];
	[masterButton.target performSelector:masterButton.action];
	[self.splitVC.masterVC displayCheckmark:record];
}

-(IBAction) deleteRecord:(id)sender {
	[self doConfirmDialogueWithTitle:@"Delete Record" message:@"Are you sure you want to delete this record?"];
}

-(void) deleteRecordConfirmed {
	// Delete from Core Data + refresh master list
	[self.splitVC.masterVC.dataController deleteRecord:record];
	[self.splitVC.masterVC.tableView reloadData];
	
	// Clear from local memory then refresh details
	[self.record clear];
	[[self tableView] reloadData];
	
	// Update State/buttons
	[self setState:STATE_BLANK];
}

-(IBAction) editRecord:(id)sender {
	[self setState:STATE_EDIT];
	[self.titleTextField becomeFirstResponder];
	[self setActiveCellByRow:0];

}

-(IBAction) newRecord:(id)sender {
	[self setState:STATE_CREATE];
	[self.titleTextField becomeFirstResponder];
	[self setActiveCellByRow:0];
}




#pragma mark - Color comparison
BOOL colorSimilarToColor(UIColor *left, UIColor *right) {
	float tolerance = 0.05; // 5%
	
	CGColorRef leftColor = [left CGColor];
	CGColorRef rightColor = [right CGColor];
	
	if (CGColorGetColorSpace(leftColor) != CGColorGetColorSpace(rightColor)) {
		return FALSE;
	}
	
	int componentCount = CGColorGetNumberOfComponents(leftColor);
	
	const float *leftComponents = CGColorGetComponents(leftColor);
	const float *rightComponents = CGColorGetComponents(rightColor);
	
	for (int i = 0; i < componentCount; i++) {
		float difference = leftComponents[i] / rightComponents[i];
		
		if (fabs(difference - 1) > tolerance) {
			return FALSE;
		}
	}
	
	return TRUE;
}

#pragma mark - Reposition Text Fields (when keyboard is blocking them)
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
	[self setActiveCellByRow:textField.tag];
	
    [self animateTextField: textField up: NO];
}



- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
/*
	switch (textField.tag) {
		case 0:
			[textField resignFirstResponder];
			[self.usernameTextField becomeFirstResponder];
			[self setActiveCellByRow:1];
			break;
		case 1:
			[textField resignFirstResponder];
			[self.passwordTextField becomeFirstResponder];
			[self setActiveCellByRow:2];
			break;
		case 2:
			[textField resignFirstResponder];
			[self.urlTextField becomeFirstResponder];
			[self setActiveCellByRow:3];
			break;
		case 3:
			[textField resignFirstResponder];
			[self.notesTextField becomeFirstResponder];
			[self setActiveCellByRow:4];
			break;
		case 4:
			[textField resignFirstResponder];
			[self saveRecord:nil];
			[self setActiveCellByRow:-1];
			break;
		default:
			// set #1 first responder?
			break;
	}
 */
	//	}
    [self animateTextField: textField up: YES];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        const int movementDistance = 120; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}


- (IBAction)textFieldDidExit:(UITextField *)textField
{
	// INPUT COMPLETED - Confirm User Save and then Login
//    if(usernameOK && passwordOK && password2OK && securityAnswerOK) {
//		[textField resignFirstResponder];
//		[self doConfirmDialogueWithTitle:@"Save User" message:@"Be sure not to lose your username/password! Do you want to save this user?"];
//	}
	// INPUT INCOMPLETE - Set next input field to first responder
//	else {
		switch (textField.tag) {

			case 0:
				[textField resignFirstResponder];
				[self.usernameTextField becomeFirstResponder];
				[self setActiveCellByRow:1];
				break;
			case 1:
				[textField resignFirstResponder];
				[self.passwordTextField becomeFirstResponder];
				[self setActiveCellByRow:2];
				break;
			case 2:
				[textField resignFirstResponder];
				[self.urlTextField becomeFirstResponder];
				[self setActiveCellByRow:3];
				break;
			case 3:
				[textField resignFirstResponder];
				[self.notesTextField becomeFirstResponder];
				[self setActiveCellByRow:4];
				break;

			case 4:
				[textField resignFirstResponder];
				[self saveRecord:nil];
				[self setActiveCellByRow:-1];
				break;
			default:
				// set #1 first responder?
				break;
		}
//	}
	
    [self animateTextField: textField up: NO];
}

#pragma mark - Alert View Helpers/Response
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// SAVE RECORD RESPONSE
	if([alertView.title isEqualToString: @"Save Record"]) {
		if(buttonIndex == 1) { // YES
			[self saveRecordConfirmed];
		} else if (buttonIndex == 0) { // NO
			[self setActiveCellByRow:0];
		}		
	}
	// DELETE RECORD RESPONSE
	if([alertView.title isEqualToString: @"Delete Record"]) {
		if(buttonIndex == 1) { // YES
			[self deleteRecordConfirmed];
		} else if (buttonIndex == 0) { // NO
			
		}
	}
}



// Confirmation Dialogue
-(void)doConfirmDialogueWithTitle:(NSString*)title message:(NSString*)msg {
	UIAlertView *confirm = [[UIAlertView alloc] init];
	[confirm setTitle:title];
	[confirm setMessage:msg];
	[confirm setDelegate:self];
	[confirm addButtonWithTitle:@"No"];
	[confirm addButtonWithTitle:@"Yes"];
	[confirm show];
}



@end
