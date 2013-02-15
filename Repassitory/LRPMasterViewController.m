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
#import "LRPAddRecordViewController.h"
#import "LRPSplitViewController.h"
#import "LRPAppState.h"

/*
@interface LRPMasterViewController () {
    NSMutableArray *_objects;
}
@end
 */

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
    self.detailViewController = (LRPDetailViewController *)
        [[self.splitViewController.viewControllers lastObject] topViewController];

    self.dataController = [[LRPRecordDataController alloc] init];
    
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor underPageBackgroundColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    
    LRPRecord* recordAtIndex = [self.dataController recordAtIndex:indexPath.row];
    
    [[cell textLabel] setText:recordAtIndex.title];
//    [[cell detailTextLabel] setText:recordAtIndex.username];
    
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
         LRPRecord* currentRecord = [self.dataController recordAtIndex:indexPath.row];
//        [self.splitVC.detailVC setRecord:currentRecord];
        [self.detailViewController setRecord:currentRecord];
    
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LRPRecord* selectedRecord = [self.dataController recordAtIndex:indexPath.row];
        [[segue destinationViewController] setRecord:selectedRecord];
    }
}



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

- (void)viewWillAppear:(BOOL)animated
{    
    // register self with SplitVC
    self.splitVC = (LRPSplitViewController *)self.splitViewController;
    self.splitVC.masterVC = self;

    // Check for valid Data Controller
    if (!_dataController) {
        self.dataController = [[LRPRecordDataController alloc] init];
    }
    if(![self.dataController loadUserRecordsFromContext]) {
        // error loading user records
    }
    [self.tableView reloadData];
}

#pragma mark - User Functions
- (void) loadUserRecords {
    [_dataController loadUserRecordsFromContext];    
    [self.tableView reloadData];
}

@end
