//
//  LRPStartViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 2/18/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPStartViewController.h"

#import "LRPAppState.h"
#import "MBAlertView.h"

@interface LRPStartViewController ()

@end

@implementation LRPStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Add extra buttons to nav bar
	UIBarButtonItem* loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"   Login   " style:UIBarButtonItemStyleBordered target:self action:@selector(loadLogin:)];
	UIBarButtonItem* newUserBtn = [[UIBarButtonItem alloc] initWithTitle:@"New User" style:UIBarButtonItemStyleBordered target:self action:@selector(loadNewUser:)];
	
	NSArray* rBtnList = [[NSArray alloc] initWithObjects:loginBtn, newUserBtn, nil];
	self.navigationItem.rightBarButtonItems = rBtnList;
	
	UIBarButtonItem* aboutBtn = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(showAppInfo:)];
	
	NSArray* lBtnList = [[NSArray alloc] initWithObjects:aboutBtn, nil];
	self.navigationItem.leftBarButtonItems = lBtnList;

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) showAppInfo:(id)sender {
	[LRPAppState showAppInfo];
}


- (IBAction) loadNewUser:(id)sender {
	[self performSegueWithIdentifier:@"startToNewUser" sender:sender];
}

- (IBAction) loadLogin:(id)sender {
	[self performSegueWithIdentifier:@"startToLogin" sender:sender];
}

@end
