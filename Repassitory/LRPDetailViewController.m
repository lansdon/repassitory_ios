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
#import "LRPScreenAdjust.h"
#import "LRPAlertView.h"
#import "LRPAppDelegate.h"
#import "LRPAlertViewQueue.h"
#import "LRPAlertViewController.h"
#import "MBProgressHUD.h"


@interface LRPDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

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

    // Record Label
	[self updateRecordVaultLabel];

    // Update the user interface for the detail item.
    if (![self.record.title isEqualToString:@""]) {
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
        
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor clearColor];

	// Setup Screen Scrolling Mechanism
	self.screenAdj = [[LRPScreenAdjust alloc]
					  initWithActiveViews:[[NSArray alloc] initWithObjects:
										   self.titleTextField,
										   self.usernameTextField,
										   self.passwordTextField,
										   self.urlTextField,
										   self.notesTextField,
										   nil]
					  inContainingView:self.view
					  inTable:self.tableView];

	self.splitVC.detailvc_loaded = true;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"detailvc_did_load" object:nil];
	NSLog(@"Detail - view did load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view
-(void) updateRecordVaultLabel {
	if(self.btnRecordVault) {
		self.btnRecordVault.title = [NSString stringWithFormat:@"Record Vault (%d items)", [self.splitVC.masterVC.dataController countOfListInSection:0]];
//		[self.navigationItem setLeftBarButtonItem:nil animated:YES];
//		[self.navigationItem setLeftBarButtonItem:self.btnRecordVault animated:YES];
		
//		[self.splitViewController.view setNeedsLayout];
	}
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
	_btnRecordVault = barButtonItem;
	[self updateRecordVaultLabel];
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
	if(!self.record) {
		self.record = [LRPRecord alloc];
	}
	[self.record clear];
		
    [self configureView];
}



/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DoLoginSegue"]) {
        // Set managed object on Split View
        LRPLoginViewController* loginVC = [segue destinationViewController];
        loginVC.splitVC = self.splitVC;
    }
}
*/




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
//	NSArray* indexPaths = [self.tableView numberOfRowsInSection:0];
	for(int i=0; i<[self.tableView numberOfRowsInSection:0]; ++i) {
//		UITableViewCell* cell = indexPaths[i];
		UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if(row == i) {
			[cell setBackgroundColor:[UIColor blueColor]];
			[self setFirstResponderByTableRow:row];
		} else {
			[cell setBackgroundColor:[UIColor clearColor]];
		}
	}	
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
	
	/*
	 Test - (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block;

	 
	 */
	
	void(^saveBlock)(void) = ^{
		/**
		 Save record to coredata
		 */
		
		// Need to remove old record?   (this should be redone to use core data object directly?)
		if(self.editingExistingRecord) {
			[self.splitVC.masterVC.dataController deleteRecord:record];
			[self.record clear];
		}
		
		// Update local record using input fields
		if(!record) record = [LRPRecord alloc];
		self.record = [self.record initWithTitle:titleTextField.text
										username:usernameTextField.text
										password:passwordTextField.text
											 url:urlTextField.text
										   notes:notesTextField.text];
		
		// Clear previous record checkmarks
		[self.splitVC.masterVC.dataController setCheckmarkForNewRecord:false];
		// Save local record to core data
		[self.splitVC.masterVC.dataController addRecord:record];
		
		// Update button states
		[self setState:STATE_DISPLAY];
	};
	
	void(^saveCompletionBlock)(void) = ^{
		//			[self.view setNeedsDisplay];
		[self.tableView reloadData];
		[self.splitVC.masterVC reloadData];
		[self displayMasterVC];
		[self.splitVC.masterVC.dataController setCheckmarkForNewRecord:YES];

//		dispatch_async(dispatch_get_main_queue(), ^{
		/*
			MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
			hud.mode = MBProgressHUDModeCustomView;
			hud.labelText = [NSString stringWithFormat:@"Saving %@...", self.record.title];
			hud.detailsLabelText = @"Success!";
			
			hud.labelFont = [UIFont boldSystemFontOfSize:40];
			hud.detailsLabelFont = [UIFont boldSystemFontOfSize:36];
			hud.minShowTime = 1.0;
			hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.jpeg"]];
			hud.dimBackground = true;
			[hud hide:YES afterDelay:1.0];
			*/
			//			[self.splitVC.masterVC reloadData];
			//			[self.splitVC.masterVC.view setNeedsDisplay];
			//			[self.view setNeedsDisplay];
//		});
	};
		
		


	
		
	
		
	/*
	 
				End test
	 */
	
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.labelText = [NSString stringWithFormat:@"Saving %@...", self.record.title];
	hud.labelFont = [UIFont boldSystemFontOfSize:40];
	hud.minShowTime = 1.0;
	hud.dimBackground = true;
	[hud showAnimated:YES whileExecutingBlock:saveBlock completionBlock:saveCompletionBlock];

	// Clear previous record checkmarks
//	[self.splitVC.masterVC.dataController setCheckmarkForNewRecord:false];
/*
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		///
			//Save record to coredata
		 //
		
		// Need to remove old record?   (this should be redone to use core data object directly?)
		if(self.editingExistingRecord) {
			[self.splitVC.masterVC.dataController deleteRecord:record];
			[self.record clear];
		}
		
		// Update local record using input fields
		if(!record) record = [LRPRecord alloc];
		self.record = [self.record initWithTitle:titleTextField.text
										username:usernameTextField.text
										password:passwordTextField.text
										url:urlTextField.text
										notes:notesTextField.text];
				
		// Save local record to core data
		[self.splitVC.masterVC.dataController addRecord:record];
		
		// Update button states
		[self setState:STATE_DISPLAY];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			//			[self.view setNeedsDisplay];
			//[self.tableView reloadData];
			[self.splitVC.masterVC reloadData];
			[self displayMasterVC];
		});
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.splitVC.masterVC.dataController setCheckmarkForNewRecord:YES];
		});

		dispatch_async(dispatch_get_main_queue(), ^{
			[MBProgressHUD hideHUDForView:self.view animated:NO];
		});
		

		dispatch_async(dispatch_get_main_queue(), ^{
			MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
			hud.mode = MBProgressHUDModeCustomView;
			hud.labelText = [NSString stringWithFormat:@"Saving %@...", self.record.title];
			hud.detailsLabelText = @"Success!";
			
			hud.labelFont = [UIFont boldSystemFontOfSize:40];
			hud.detailsLabelFont = [UIFont boldSystemFontOfSize:36];
			hud.minShowTime = 1.0;
			hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.jpeg"]];
			hud.dimBackground = true;
			[hud hide:YES afterDelay:1.0];
			
//			[self.splitVC.masterVC reloadData];
//			[self.splitVC.masterVC.view setNeedsDisplay];
//			[self.view setNeedsDisplay];
		});
	});
 */
}

// Function seperated for delayed use
- (void) displayMasterVC {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (!UIInterfaceOrientationIsLandscape(orientation)) {
		UIBarButtonItem* masterButton = self.navBar.leftBarButtonItems[0];
		if(masterButton) {
			[masterButton.target performSelector:masterButton.action];
		}
	}
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



#pragma mark - Reposition Text Fields (when keyboard is blocking them)
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
//	[self setActiveCellByRow:textField.tag];
	[self.screenAdj viewBecameActive:textField];
}



- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
//	[self.screenAdj viewBecameInactive:textField];
}


- (IBAction)textFieldDidExit:(UITextField *)textField
{
	[self.screenAdj viewBecameInactive:textField];

	switch (textField.tag) {

			case 0: 
			case 1: 
			case 2: 
			case 3: 
				[self setActiveCellByRow:textField.tag+1];
				break;
				
			case 4:
//				[textField resignFirstResponder];
//				[UIView beginAnimations: @"anim" context: nil];
//				[UIView setAnimationBeginsFromCurrentState: YES];
//				[UIView setAnimationDuration: 0.3];
//				self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//				[UIView commitAnimations];
				[self saveRecord:nil];
				[self setActiveCellByRow:-1];
				break;
			default:
				[self setActiveCellByRow:textField.tag+1];
				break;
		}
//	}
	
//    [self animateTextField: textField up: YES];
}

#pragma mark - Alert View Helpers/Response


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
