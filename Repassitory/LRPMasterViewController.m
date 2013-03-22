//
//  LRPMasterViewController.m
//  SplitTest
//
//  Created by Lansdon Page on 1/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPMasterViewController.h"

#import "LRPDetailViewController.h"
#import "LRPRecordDataController.h"
#import "LRPRecord.h"
#import "Record.h"
#import "LRPSplitViewController.h"
#import "LRPAppState.h"
#import "LRPUser.h"
#import "LRPAppDelegate.h"


@interface LRPMasterViewController()
@property LRPAppDelegate* appDelegate;
@end

@implementation LRPMasterViewController
@synthesize appDelegate;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}





- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataController = [[LRPRecordDataController alloc] initWithMasterVC:self];

	// Register with delegate
	appDelegate = [(LRPAppDelegate*)[[UIApplication sharedApplication] delegate] registerViewController:self];
    appDelegate.masterVC = self;

    // opaque background exposes window image
    self.view.backgroundColor = [UIColor clearColor];
	
	// New Record Button
//	UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(newRecord)];
	UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newRecord)];
		[self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];

	appDelegate.mastervc_loaded = true;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"mastervc_did_load" object:nil];

	NSLog(@"Master - view did load");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// hide toolbar (iphone only)
	if([LRPAppState isIphone]) {
		[self.navigationController setToolbarHidden:YES animated:NO];
	}
	
    // register self with SplitVC
    appDelegate.splitVC = (LRPSplitViewController *)self.splitViewController;
		appDelegate.masterVC = self;
	
    // Check for valid Data Controller
    if (!_dataController) {
        self.dataController = [[LRPRecordDataController alloc] initWithMasterVC:self];
    }

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self.dataController.lastNewRecord clear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		appDelegate.currentRecord = [self.dataController.fetchedResultsController objectAtIndexPath:indexPath];
//        LRPRecord* selectedRecord = [self.dataController recordAtIndexPath:indexPath];
		
//        [[segue destinationViewController] setRecord:selectedRecord];
    }
}


#pragma mark - Table View


- (void) tableViewBeginUpdates {
	[self.tableView beginUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfListInSection:section];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecordCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	[self.dataController configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	LRPRecord* currentRecord = [self.dataController recordAtIndexPath:indexPath];
	appDelegate.currentRecord = [self.dataController.fetchedResultsController objectAtIndexPath:indexPath];

	// If the cell selected is different than lastNewRecord, clear lastNewRecord
	if(!([self.dataController.lastNewRecord.title isEqualToString:appDelegate.currentRecord.title] &&
		 [self.dataController.lastNewRecord.password isEqualToString:appDelegate.currentRecord.password] &&
		 [self.dataController.lastNewRecord.username isEqualToString:appDelegate.currentRecord.username] &&
		 self.dataController.lastNewRecord.user_id == appDelegate.currentRecord.user_id &&
		 [self.dataController.lastNewRecord.notes isEqualToString:appDelegate.currentRecord.notes])) {
		[self.dataController clearNewRecord];
	}

    
	if ([LRPAppState isIpad]) {
		[appDelegate.detailVC configureView];
    }
	
	else if([LRPAppState isIphone]) {
		[self performSegueWithIdentifier:@"master_to_detail"  sender:self];
	}
}




#pragma mark - User Functions

- (void) newRecord {
	appDelegate.currentRecord = nil;
//	appDelegate.detailVC a
	if([LRPAppState isIphone]) {
		[self performSegueWithIdentifier:@"master_to_detail" sender:self];
	} else {
		[appDelegate.detailVC dismissMasterVC];
	}
}

- (BOOL)loadUserRecordsFromContext {	// helper function to call load from datacontroller
	return [self.dataController loadUserRecordsFromContext];
}


- (void) reloadData {
	[self.tableView reloadData];
	[appDelegate.detailVC configureView]; // was update vault button
	
	NSLog(@"Master - reloadData");
}

#pragma mark - Alert View Helpers/Response
@end
