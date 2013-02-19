//
//  LRPStartViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 2/18/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPStartViewController.h"

#import "LRPAppState.h"

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
	// Do any additional setup after loading the view.

	// Add extra buttons to nav bar
	UIBarButtonItem* loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"   Login   " style:UIBarButtonItemStyleBordered target:self action:@selector(loadLogin:)];
	UIBarButtonItem* newUserBtn = [[UIBarButtonItem alloc] initWithTitle:@"New User" style:UIBarButtonItemStyleBordered target:self action:@selector(loadNewUser:)];
	
	NSArray* rBtnList = [[NSArray alloc] initWithObjects:loginBtn, newUserBtn, nil];
	self.navigationItem.rightBarButtonItems = rBtnList;
	
	//	UIBarButtonItem* exitBtn = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(resignAndLogin:)];
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
//	[LRPAppState showAppInfo];
		
		NSString* aboutMsg = [[NSString alloc] initWithFormat:
							  @"Repassitory\n"
							  "Version %@\n"
							  "By Lansdon Page\n"
							  "Copyright 2013\n"
							  "\n"
							  "Repassitory is a password database where you can store "
							  "your passwords in one spot. You'll never lose those annoying, "
							  "infrequently used passwords again!\n"
							  "\n"
							  "Security: Repassitory uses a powerful AES encryption algorithm "
							  "in combination with Apple's Core Data storage technology. This means "
							  "your information is stored on your device in a secure encrypted format "
							  "that only YOU can get to!", [LRPAppState getVersion]];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithFrame:CGRectMake(0, 0, 400, 750)];
//		alert.frame = CGRectMake(0, 0, 300, 800);
//		[alert autoresizesSubviews];
//		[alert setFrame:CGRectMake(0, 0, 300, 300)];
		[alert setTitle:@"About Repassitory"];
		[alert setMessage:aboutMsg];
		[alert setAutoresizesSubviews:YES];
		[alert setDelegate:self];
		[alert addButtonWithTitle:@"OK"];
		[alert show];
		
}
- (void)willPresentAlertView:(UIAlertView *)alertView {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	
	CGFloat alertOriginX = screenWidth/4;
	CGFloat alertOriginY = screenHeight/4;
	CGFloat alertWidth = (screenWidth/4)*2;
	CGFloat alertHeight = (screenHeight/4)*2;
	
	
	alertView.frame = CGRectMake(alertOriginX, alertOriginY, alertWidth, alertHeight);
	[alertView autoresizesSubviews];
    for ( UIView *views in [alertView subviews]) {
//        NSLog(@"%@",views);				
        if (views.tag == 12345) {
			[views setFrame:CGRectMake(alertWidth*.05, alertHeight*.12, alertWidth*.90, alertHeight*.75)];
		}
		if (views.tag == 1) {
			[views setFrame:CGRectMake(alertWidth*.05, alertHeight*.88, alertWidth*.90, alertHeight*.1)];
        }
    }
}

- (IBAction) loadNewUser:(id)sender {
	[self performSegueWithIdentifier:@"startToNewUser" sender:sender];
}

- (IBAction) loadLogin:(id)sender {
	[self performSegueWithIdentifier:@"startToLogin" sender:sender];
}

@end
