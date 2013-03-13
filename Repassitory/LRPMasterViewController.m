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
#import "LRPSplitViewController.h"
#import "LRPAppState.h"
#import "LRPAlertView.h"
#import "LRPUser.h"


@implementation LRPMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];

//    self.dataController = [[LRPRecordDataController alloc] initWithUser:[LRPAppState currentUser]];

}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
/*
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
 */

    self.dataController = [[LRPRecordDataController alloc] initWithMasterVC:self];

    // register self with SplitVC
    self.splitVC = (LRPSplitViewController *)self.splitViewController;
    self.splitVC.masterVC = self;

    self.detailViewController = (LRPDetailViewController *)
	[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor clearColor];

}

- (void)viewWillAppear:(BOOL)animated
{
    // register self with SplitVC
    self.splitVC = (LRPSplitViewController *)self.splitViewController;
    self.splitVC.masterVC = self;
	
    // Check for valid Data Controller
    if (!_dataController) {
        self.dataController = [[LRPRecordDataController alloc] initWithMasterVC:self];
    }
//    if(![self.dataController loadUserRecordsFromContext]) {
        // error loading user records
//    }
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	if(![self.dataController.lastNewRecord.title isEqualToString:@""]) {
		[self.dataController setCheckmarkForNewRecord:YES];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
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
        LRPRecord* selectedRecord = [self.dataController recordAtIndexPath:indexPath];
        [[segue destinationViewController] setRecord:selectedRecord];
    }
}


/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/

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
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
 //       [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
         LRPRecord* currentRecord = [self.dataController recordAtIndexPath:indexPath];
        [self.detailViewController setRecord:currentRecord];
		
		// If the cell selected is different than lastNewRecord, clear lastNewRecord
		if(!([self.dataController.lastNewRecord.title isEqualToString:currentRecord.title] &&
		   [self.dataController.lastNewRecord.password isEqualToString:currentRecord.password] &&
		   [self.dataController.lastNewRecord.username isEqualToString:currentRecord.username] &&
		   self.dataController.lastNewRecord.user_id == currentRecord.user_id &&
		   [self.dataController.lastNewRecord.notes isEqualToString:currentRecord.notes])) {
			[self.dataController clearNewRecord];
		}
    }
}



/*
- (IBAction)done:(UIStoryboardSegue *)segue
{

    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        
        LRPAddRecordViewController *addController = [segue sourceViewController];
        if (addController.record) {
            [self.dataController addRecord:addController.record];
            [[self tableView] reloadData];
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }

}


- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
 */

#pragma mark - User Functions
/*
- (void) loadUserRecords {
	
	// Setup Alert Window
	self.activityAlert = [[LRPAlertView alloc] init];
	[self.activityAlert.title setText:@"Load Records"];
	[self.activityAlert.message setText:[NSString stringWithFormat:@"Retrieving records for %@",[LRPAppState currentUser].username]];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimating) name:@"loadRecordsStart" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimating) name:@"loadRecordsDone" object:nil];
	
	[self.activityAlert startAnimating];
	[self.activityAlert showAlert];

	[self performSelectorInBackground:@selector(_laodUserRecords) withObject:nil];

	
//	[activityAlert dismissAlert];
}

// Private method (contains body for background processing)
- (void) _loadUserRecords {
	[_dataController loadUserRecordsFromContext];
	[self reloadData];
	[self.detailViewController updateRecordVaultLabel];	
}
*/

- (void) reloadData {
//	[self.tableView reloadData];
	[self.detailViewController updateRecordVaultLabel];
}

#pragma mark - Alert View Helpers/Response
/*
- (void) startAnimating {
//	[self.activityAlert.message setText:@"Saving record..."];
	[self.activityAlert startAnimating];
}

- (void) stopAnimating {
	[self.activityAlert stopAnimating];
	[self.activityAlert dismissAlert];
}
*/
@end
