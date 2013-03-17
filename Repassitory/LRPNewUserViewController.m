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

@interface LRPNewUserViewController ()

@end

@implementation LRPNewUserViewController
//@synthesize securityQuestions, picker;


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
/*
    self.securityQuestions = [[NSArray alloc]
                              initWithObjects:
							  @"<Choose a question>",
							  @"What's your favorite pet's name?",
                              @"What city were you born in?",
                              @"How many fingers am I holding up?",
                              @"What's your favorite number?",
                              @"How many digits of PI can you recite?", nil];
*/    
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
//	securityQuestionOK = NO;
//	securityAnswerOK = NO;

//	securityQuestionIndex = 0;

	
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

/*
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [securityQuestions count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [securityQuestions objectAtIndex:row];
}
*/

#pragma mark PickerView Delegate


/*
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
	securityQuestionIndex = row;
	[self validateSecurityQuestion];
}

*/


#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {	// YES
		[self saveUser:nil];
	}
	//	if (buttonIndex == 0) {			// NO
	//	}
}

// Confirmation Dialogue
-(void)doConfirmDialogueWithTitle:(NSString*)title message:(NSString*)msg {
	UIAlertView *confirm = [[UIAlertView alloc] init];
	[confirm setTitle:title];
	[confirm setMessage:msg];
	[confirm setDelegate:self];
	[confirm addButtonWithTitle:@"No"];
	[confirm addButtonWithTitle:@"Yes"];
	[confirm show];
}

#pragma mark - User functions
// Save button pressed
-(IBAction)saveUser:(id)sender {
    LRPUser* newUser = [[LRPUser alloc] initWithName:[self.usernameInput text] password:[self.passwordInput text]];
//    [newUser setSecurity_question:[NSNumber numberWithInteger:securityQuestionIndex]];
//	[newUser setSecurity_answer:[self.securityAnswerInput text]];
	
     if([CoreDataHelper createNewUserFromObject:newUser]) {
         // login after creation
		 [self loginUser:newUser];
	 } else {
     
         // ERROR CREATING USER - todo: send error message
         UIAlertView *alert = [[UIAlertView alloc]
                               initWithTitle:@"Error - Failed to create user"
                               message:@"That username/password combination is invalid. Please try again."
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
         [alert show];
//         [usernameField setText:@""];
//         [passwordField setText:@""];
     
     NSLog(@"Error - Failed to create new user");
//     */
     }
}

-(bool)loginUser:(LRPUser*)user {

    NSLog(@"Logging in user:%@, pass:%@, key:%@", user.username, user.password, [LRPAppState getKey]);

    User* userLoggingIn = [CoreDataHelper getUser:user];
	
    if(![userLoggingIn.username isEqualToString:@""] &&
	   ![userLoggingIn.password isEqualToString:@""] &&
	   userLoggingIn != nil) {
		
        user = [user initWithUser:userLoggingIn];
        [LRPAppState setCurrentUser:user];
    
        // Load new root view from app delegate
        [self dismissViewControllerAnimated:true completion:nil];
        LRPAppDelegate *appDelegate = (LRPAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loginSuccessfull];
        
    } else {
        // ERROR CREATING USER
		[LRPAppState reset];
        UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle:@"Login Error!"
                            message:@"Invalid username/password. Please try again."
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
        [alert show];
        [self.passwordInput setText:@""];
        [self.passwordInput becomeFirstResponder];
    
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
//        [self.saveButton rightBarButtonItem].alpha = 1.0;
//        self.saveButton.enabled = YES;
    } else {
//        self.saveButton.alpha = 0.4;
//        self.saveButton.enabled = NO;
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
		[self doConfirmDialogueWithTitle:@"Save User" message:@"Be sure not to lose your username/password! Do you want to save this user?"];
	}
}




@end
