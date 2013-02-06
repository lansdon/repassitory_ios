//
//  LRPAddRecordViewController.m
//  SplitTest
//
//  Created by Lansdon Page on 1/14/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAddRecordViewController.h"

#import "LRPRecord.h"
#import "LRPSplitViewController.h"


@interface LRPAddRecordViewController ()

@end

@implementation LRPAddRecordViewController
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.titleInput) || (textField == self.usernameInput) ||
        (textField == self.passwordInput) || (textField == self.urlInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view delegate


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        if ([self.titleInput.text length]) {
            self.record = [[LRPRecord alloc] initWithTitle:self.titleInput.text
                                        username:self.usernameInput.text
                                        password:self.passwordInput.text
                                        url:self.urlInput.text notes:@"" ];
                                        //self.notesInput.text];
 //           self.record = record;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Obtain managedContext
    self.splitVC = (LRPSplitViewController *)self.splitViewController;
//    self.managedObjectContext = self.splitVC.managedObjectContext;
    
    // register self with SplitVC
    self.splitVC.addVC = self;
}

@end
