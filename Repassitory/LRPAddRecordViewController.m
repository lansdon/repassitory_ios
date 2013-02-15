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
    
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor underPageBackgroundColor];

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
        (textField == self.passwordInput) || (textField == self.urlInput) ||
        (textField == self.notesInput)) {
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
                                        url:self.urlInput.text
                                        notes:self.notesInput.text];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Obtain managedContext
    self.splitVC = (LRPSplitViewController *)self.splitViewController;
    
    // register self with SplitVC
    self.splitVC.addVC = self;
}

#pragma mark - Reposition Text Fields (when keyboard is blocking them)
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
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

@end
