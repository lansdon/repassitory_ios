//
//  LRPNewUserViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 2/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPNewUserViewController.h"

#import "CoreDataHelper.h"
#import "LRPUser.h"
#import "LRPAppDelegate.h"
#import "User.h"
#import "LRPAppState.h"
#import "LRPScreenAdjust.h"
#import "MBAlertView.h"


@interface LRPNewUserViewController ()
@property LRPAppDelegate* appDelegate;

@end

@implementation LRPNewUserViewController
@synthesize appDelegate;


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
	
	self.appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];

    // opaque background exposes window image
    self.view.backgroundColor = [UIColor clearColor];
	
	// Setup Screen Scrolling Mechanism
	self.screenAdj = [[LRPScreenAdjust alloc]
					  initWithActiveViews:[[NSArray alloc] initWithObjects:
										   self.usernameInput,
										   self.passwordInput,
										   self.password2Input,
										   nil]
					  inContainingView:self.view
					  inTable:self.tableView];

	[self.usernameInput becomeFirstResponder];
	
    // Initialize Field Toggles
    usernameOK = NO;
    passwordOK = NO;
    password2OK = NO;
	
	[self validatePassword2:nil];
    [self updateSaveButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
	[self dismissViewControllerAnimated:false completion:nil];
}


#pragma mark - User functions
// Save button pressed
-(IBAction)saveUser:(id)sender {
    if(usernameOK && passwordOK && password2OK) { // &&
		LRPUser* newUser = [[LRPUser alloc] initWithName:[self.usernameInput text] password:[self.passwordInput text]];
	
		 if([CoreDataHelper createNewUserFromObject:newUser]) {
			 // login after creation
			 [self loginUser:newUser];
		 } else {
		 
			 // ERROR CREATING USER - todo: send error message
			 MBAlertView *alert = [MBAlertView alertWithBody:@"Error creating user account." cancelTitle:@"OK" cancelBlock:nil];
			 alert.bodyFont = [appDelegate alertFontTitle];
			 [alert addToDisplayQueue];

			 NSLog(@"Error - Failed to create new user");
		 }
	} else {
		// ERROR CREATING USER - todo: send error message
		MBAlertView *alert = [MBAlertView alertWithBody:@"Invalid fields!" cancelTitle:@"OK" cancelBlock:nil];
		alert.bodyFont = [appDelegate alertFontTitle];
		[alert addToDisplayQueue];
		
		NSLog(@"Error - Failed to create new user(invalid fields)");		
	}
}

-(bool)loginUser:(LRPUser*)user {

    NSLog(@"Logging in user:%@, pass:%@, key:%@", user.username, user.password, [LRPAppState getKey]);

//	LRPAppDelegate *appDelegate = (LRPAppDelegate *)[[UIApplication sharedApplication] delegate];
    User* userLoggingIn = [CoreDataHelper getUser:user];
	
    if(![userLoggingIn.username isEqualToString:@""] &&
	   ![userLoggingIn.password isEqualToString:@""] &&
	   userLoggingIn != nil) {
		
        user = [user initWithUser:userLoggingIn];
        [LRPAppState setCurrentUser:user];
    
        // Load new root view from app delegate
        [self dismissViewControllerAnimated:true completion:nil];
        [appDelegate openRecords];
    }

	// ERROR - LOgging in
	else {
		[LRPAppState reset];
		MBAlertView *alert = [MBAlertView alertWithBody:@"Invalid username/password. Please try again." cancelTitle:@"OK" cancelBlock:nil];
		alert.bodyFont = appDelegate.alertFontBody;
		[alert addToDisplayQueue];
   
        NSLog(@"Error - Login attempt failed for %@", [self.usernameInput text]);    
    }
	return true;
}



// Cancel Button
-(IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:false completion:nil];
}


#pragma mark - Validation
/*
-(bool)validateSecurityQuestion {
	if(securityQuestionIndex > 0) {
        self.securityQuestionFeedback.text = @"OK!";
        self.securityQuestionFeedback.textColor = [UIColor greenColor];
        securityQuestionOK = YES;		
	} else {
        self.securityQuestionFeedback.text = @"(*Required)";
        self.securityQuestionFeedback.textColor = [UIColor redColor];
        securityQuestionOK = NO;
	}
}
*/

// Username incrimental validation (confirm username isn't used)
-(IBAction)validateUsername:(id)sender {
    
    if([self.usernameInput.text isEqualToString:@""]) {                                  // 1. No Input
        self.usernameFeedback.text = @"(*Required)";
        self.usernameFeedback.textColor = [UIColor redColor];
        usernameOK = false;
    }
    else if([self.usernameInput.text length] < 5) {                                       // 2. Min 5 chars
        self.usernameFeedback.text = @"(Minimum 5 characters)";
        self.usernameFeedback.textColor = [UIColor redColor];
        usernameOK = false;
    }
    else if([CoreDataHelper usernameExistsByString:[[self usernameInput] text]]) {           // 3. Error name found
        self.usernameFeedback.text = @"Username already in use!";
        self.usernameFeedback.textColor = [UIColor redColor];
        usernameOK = false;
    }
    else {                                                                                  // SUCCESS
        self.usernameFeedback.text = @"OK!";
        self.usernameFeedback.textColor = [UIColor greenColor];
        usernameOK = true;
    }
    [self updateSaveButton];
}

// Check password
-(IBAction)validatePassword:(id)sender {
    if([self.passwordInput.text isEqualToString:@""]) {                                  // 1. No Input
        self.passwordFeedback.text = @"(*Required)";
        self.passwordFeedback.textColor = [UIColor redColor];
        passwordOK = NO;
    }
    else if([self.passwordInput.text length] < 5) {                                       // 2. Min 5 chars
        self.passwordFeedback.text = @"(Minimum 5 characters)";
        self.passwordFeedback.textColor = [UIColor redColor];
        passwordOK = NO;
    }
    else {                                                                                  // SUCCESS
        self.passwordFeedback.text = @"OK!";
        self.passwordFeedback.textColor = [UIColor greenColor];
        passwordOK = YES;
    }
    
	[self validatePassword2:sender];
	
//    [self updateSaveButton];
	
}


// Check password
-(IBAction)validatePassword2:(id)sender {

	// Second Password field is grayed out unless first password is OK
	if(passwordOK) {
        self.password2Input.alpha = 1.0;
        self.password2Input.enabled = YES;

		// Do validation matching password1
		if(![self.password2Input.text isEqualToString:self.passwordInput.text]) {                 // 1. No
			self.password2Feedback.text = @"(Passwords do not match!)";
			self.password2Feedback.textColor = [UIColor redColor];
			password2OK = NO;
		}
		else if([self.password2Input.text isEqualToString:@""]) {                                  // 1. No Input
			self.password2Feedback.text = @"(*Required)";
			self.password2Feedback.textColor = [UIColor redColor];
			password2OK = NO;
		}
		else if([self.password2Input.text length] < 5) {                                       // 2. Min 5 chars
			self.password2Feedback.text = @"(Minimum 5 characters)";
			self.password2Feedback.textColor = [UIColor redColor];
			password2OK = NO;
		} else {                                                                                  // SUCCESS
			self.password2Feedback.text = @"OK!";
			self.password2Feedback.textColor = [UIColor greenColor];
			password2OK = YES;
		}
    } else {
        self.password2Input.alpha = 0.4;
        self.password2Input.enabled = NO;
    }
    [self updateSaveButton];
}
/*
// Check Security Answer
-(IBAction)validateSecurityAnswer:(id)sender {
    if([self.securityAnswerInput.text isEqualToString:@""]) {                                  // 1. No Input
        self.securityAnswerFeedback.text = @"(*Required)";
        self.securityAnswerFeedback.textColor = [UIColor redColor];
        securityAnswerOK = false;
    } else {                                                                                  // SUCCESS
        self.securityAnswerFeedback.text = @"OK!";
        self.securityAnswerFeedback.textColor = [UIColor greenColor];
        securityAnswerOK = true;
    }
    [self updateSaveButton];
}
*/

#pragma mark - Update
-(void)updateSaveButton {
    if(usernameOK && passwordOK && password2OK) { // && securityAnswerOK && securityQuestionOK) {
        self.navigationController.navigationItem.rightBarButtonItem.enabled = true;
//        self.navigationController.navigationItem.rightBarButtonItem. = 1.0;
    } else {
        self.navigationController.navigationItem.rightBarButtonItem.enabled = false;
//        [self.navigationController.navigationItem.rightBarButtonItem].alpha = 0.4;
    }
}



#pragma mark - Reposition Text Fields (when keyboard is blocking them)
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
	[self.screenAdj viewBecameActive:textField];
}


- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
}


- (IBAction)textFieldDidExit:(UITextField *)textField
{
	[self.screenAdj viewBecameInactive:textField];

	// INPUT COMPLETED - Confirm User Save and then Login
    if(usernameOK && passwordOK && password2OK) {
		
		MBAlertView *alert = [MBAlertView alertWithBody:@"Be sure not to lose your username/password! Do you want to save this user?" cancelTitle:@"Cancel" cancelBlock:nil];
		[alert setTitle:@"Save User"];
		alert.bodyFont = appDelegate.alertFontBody;
		[alert addButtonWithText:@"Save" type:MBAlertViewItemTypePositive block:^{
			[self saveUser:nil];
		}];
        alert.size = CGSizeMake(275, 175);
		
		[alert addToDisplayQueue];
	}

}




@end
