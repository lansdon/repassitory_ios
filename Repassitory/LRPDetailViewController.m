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
- (void)configureView;
-(void) saveRecord;
-(void) deleteRecord;

@end



@implementation LRPDetailViewController
@synthesize segmentedControl;
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
    // Test for user logged in
    if ( [LRPAppState checkForUser] ) {
        NSString* temp = [[NSString alloc] initWithFormat:@"Welcome, %@", [LRPAppState currentUser].username];
		[[self navigationController] setTitle:temp];
		//self.currentUserLabel.text = temp;
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
    [self configureView];

    self.splitVC = (LRPSplitViewController *)self.splitViewController;
    
    // register self with SplitVC
    self.splitVC.detailVC = self;
    
    // Test for user logged in
    if ( [LRPAppState checkForUser] ) {
    }
    
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

#pragma mark - Segmented Control (Buttons)

-(IBAction) segmentedControlIndexChanged {
	switch (self->segmentedControl.selectedSegmentIndex) {

		case BTN_DELETE:			
			// Todo -- Delete Record
			[self deleteRecord];
			[self setState:STATE_BLANK];
			break;
		case BTN_EDIT:
			[self setState:STATE_EDIT];
			break;
		case BTN_NEW:
			[self setState:STATE_CREATE];
			break;
		case BTN_SAVE:
			[self saveRecord];
			[self setState:STATE_DISPLAY];
			break;
			
		default:
			break;
	}
//	self->segmentedControl.selectedSegmentIndex = -1;
}

-(void) setState:(int)newState {
	currentState = newState;
	[self updatePageComponents];
}

-(void) updatePageComponents {
	switch (currentState) {
		case STATE_BLANK:
			[self disableInputFields];
			titleTextField.text = @"(Select/create a record)";
			self.usernameTextField.text = @"";
			self.passwordTextField.text = @"";
			self.urlTextField.text = @"";
			self.dateLabel.text = @"";
			self.notesTextField.text = @"";
			
			break;
			
		case STATE_CREATE:
			[self.record clear];
			[self enableInputFields];
			titleTextField.text = @"";
			usernameTextField.text = @"";
			passwordTextField.text = @"";
			urlTextField.text = @"";
			dateLabel.text = @"";
			notesTextField.text = @"";
			break;
			
		case STATE_DISPLAY:
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
			[self enableInputFields];
			break;
			
		default:
			
			break;
	}
	[self.tableView reloadData];
	
	[self updateButtonStates];
}


-(void) updateButtonStates {
	switch (currentState) {
		case STATE_BLANK:
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_DELETE];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_EDIT];
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_NEW];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_SAVE];
			break;
			
		case STATE_CREATE:
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_DELETE];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_EDIT];
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_NEW];
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_SAVE];
			break;
			
		case STATE_DISPLAY:
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_DELETE];
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_EDIT];
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_NEW];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_SAVE];
			break;
			
		case STATE_EDIT:
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_DELETE];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_EDIT];
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_NEW];
			[segmentedControl setEnabled:YES forSegmentAtIndex:BTN_SAVE];
			break;
			
		default:
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_DELETE];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_EDIT];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_NEW];
			[segmentedControl setEnabled:NO forSegmentAtIndex:BTN_SAVE];
			break;
	}
}

-(void) disableInputFields {
	[titleTextField setEnabled:NO];
	[usernameTextField setEnabled:NO];
	[passwordTextField setEnabled:NO];
	[urlTextField setEnabled:NO];
	[notesTextField setEnabled:NO];	
}

-(void) enableInputFields {
	[titleTextField setEnabled:YES];
	[usernameTextField setEnabled:YES];
	[passwordTextField setEnabled:YES];
	[urlTextField setEnabled:YES];
	[notesTextField setEnabled:YES];
}

#pragma mark - Database / Records
-(void) saveRecord {
	if(!record) record = [LRPRecord alloc];
	self.record = [self.record initWithTitle:titleTextField.text username:usernameTextField.text password:passwordTextField.text url:urlTextField.text notes:notesTextField.text];
	[self.splitVC.masterVC.dataController addRecord:record];
//	[[self tableView] reloadData];
	[self.splitVC.masterVC.tableView reloadData];
}

-(void) deleteRecord {
	[self.splitVC.masterVC.dataController deleteRecord:record];
	[[self tableView] reloadData];
	[self.splitVC.masterVC.tableView reloadData];
	
}


@end
