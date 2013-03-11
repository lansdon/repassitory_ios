//
//  LRPLoginViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 1/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPLoginViewController.h"

#import "LRPSplitViewController.h"
#import "LRPNewUserViewController.h"
#import "CoreDataHelper.h"
#import "LRPUser.h"
#import "User.h"
#import "LRPAppState.h"
#import "LRPAppDelegate.h"
#import "LRPScreenAdjust.h"


@interface LRPLoginViewController ()
- (IBAction)resignAndLogin:(id)sender;
- (void) loginUser;

@end

@implementation LRPLoginViewController

@synthesize usernameField, passwordField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
        // Custom initialization
//    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Obtain managedContext
    if(!self.splitVC)
        self.splitVC = (LRPSplitViewController *)self.splitViewController;

    // register self with SplitVC
    if(!self.splitVC.loginVC)
        self.splitVC.loginVC = self;
	
	
	// Add extra buttons to nav bar
	UIBarButtonItem* loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"   Login   " style:UIBarButtonItemStyleBordered target:self action:@selector(resignAndLogin:)];
	UIBarButtonItem* newUserBtn = [[UIBarButtonItem alloc] initWithTitle:@"New User" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewUser:)];
	
	NSArray* rBtnList = [[NSArray alloc] initWithObjects:loginBtn, newUserBtn, nil];
	self.navigationItem.rightBarButtonItems = rBtnList;

//	UIBarButtonItem* exitBtn = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(resignAndLogin:)];
//	UIBarButtonItem* aboutBtn = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(showAppInfo:)];
	
//	NSArray* lBtnList = [[NSArray alloc] initWithObjects:aboutBtn, nil];
//	self.navigationItem.leftBarButtonItems = lBtnList;
	// Setup Screen Scrolling Mechanism

	self.screenAdj = [[LRPScreenAdjust alloc]
					  initWithActiveViews:[[NSArray alloc] initWithObjects:
										   self.usernameField,
										   self.passwordField,
										   nil]
					  inContainingView:self.view
					  inTable:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
}



//  When the view reappears after logout we want to wipe the username and password fields
- (void)viewWillAppear:(BOOL)animated
{
    [usernameField setText:@""];
    [passwordField setText:@""];
    [usernameField becomeFirstResponder];
    
    self.view.backgroundColor = [UIColor clearColor];
}


#pragma mark - User/DB Operations

- (void) loginUser {
	
	LRPUser *loginUser = [[LRPUser alloc] initWithName:[usernameField text] password:[passwordField text]];	
	[LRPAppState setKey:[passwordField text]];
	
//	NSLog(@"Logging in user:%@, pass:%@, key:%@", [usernameField text], [passwordField text], [LRPAppState getKey]);
		
	User* userLoggingIn = [CoreDataHelper getUser:loginUser];
	if((![userLoggingIn.username isEqualToString:@""] && ![userLoggingIn.password isEqualToString:@""]) &&
	   (userLoggingIn != nil)) {
		
		//  We found a matching login user!
		loginUser = [[LRPUser alloc] initWithUser:userLoggingIn];
		[LRPAppState setCurrentUser:loginUser];
		
		// Load new root view from app delegate
		LRPAppDelegate *appDelegate = (LRPAppDelegate *)[[UIApplication sharedApplication] delegate];
		[self dismissViewControllerAnimated:true completion:nil];
		[appDelegate loginSuccessfull];
		
	} else { // ERROR CREATING USER
		
		UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Login Error!"
						  message:@"Invalid username/password. Please try again."
						  delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
		[alert show];
		[passwordField setText:@""];
		[passwordField becomeFirstResponder];	
		NSLog(@"Error - Login attempt failed for %@", [usernameField text]);	
	}
}


//  When we are done editing on the keyboard
- (IBAction)resignAndLogin:(id)sender
{
	//  Get a reference to the text field on which the done button was pressed
    UITextField *tf = (UITextField *)sender;

	// Screen shift
	[self.screenAdj viewBecameInactive:tf];
    
    //  Check the tag. If this is the username field, then jump to the password field automatically
    if (tf.tag == 0) {
        [passwordField becomeFirstResponder];

    //  Otherwise we pressed done on the password field, and want to attempt login
    } else {
        //  First put away the keyboard
		if([usernameField isFirstResponder]) {
			[usernameField resignFirstResponder];
		} else if([passwordField isFirstResponder]) {
			[passwordField resignFirstResponder];
		}
        [self loginUser];
	}
}


- (IBAction) showAppInfo:(id)sender {
	[LRPAppState showAppInfo];
}

- (IBAction) createNewUser:(id)sender {
	[self performSegueWithIdentifier:@"newUserStart" sender:sender];
}




#pragma mark - Reposition Text Fields (when keyboard is blocking them)



- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
	[self.screenAdj viewBecameActive:textField];
}



- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
//    [self animateTextField: textField up: NO];
}



@end
