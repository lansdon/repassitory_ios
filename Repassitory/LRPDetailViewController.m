//
//  LRPDetailViewController.m
//  SplitTest
//
//  Created by Lansdon Page on 1/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPDetailViewController.h"

#import "LRPSplitViewController.h"
#import "LRPRecord.h"
#import "LRPUser.h"
#import "LRPLoginViewController.h"
#import "LRPAppState.h"

@interface LRPDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end



@implementation LRPDetailViewController

#pragma mark - Managing the detail item

- (void)setRecord:(LRPRecord *)newRecord
{
    if (_record != newRecord) {
        _record = newRecord;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    LRPRecord* theRecord = self.record;
    
    if (theRecord) {
        
        static NSDateFormatter *formatter = nil;
        if(!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
        }
                
        self.titleLabel.text = theRecord.title;
        self.usernameLabel.text = theRecord.username;
        self.passwordLabel.text = theRecord.password;
        self.urlLabel.text = theRecord.url;
        self.dateLabel.text = [formatter stringFromDate:(NSDate*)theRecord.updated];
        self.notesLabel.text = theRecord.notes;
        [self.tableView reloadData];
    } else {
        self.titleLabel.text = @"-";
        self.usernameLabel.text = @"-";
        self.passwordLabel.text = @"-";
        self.urlLabel.text = @"-";
        self.dateLabel.text = @"-";
        self.notesLabel.text = @"-";
        [self.tableView reloadData];
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
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
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
//        loginVC.managedObjectContext = self.managedObjectContext;
        loginVC.splitVC = self.splitVC;
    }
}

@end
