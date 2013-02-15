//
//  LRPLoginViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 1/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPLoginViewController.h"

#import "LRPSplitViewController.h"
#import "CoreDataHelper.h"
#import "LRPUser.h"
#import "User.h"
#import "LRPAppState.h"
#import "LRPAppDelegate.h"


@interface LRPLoginViewController ()
- (IBAction)resignAndLogin:(id)sender;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//  When we are done editing on the keyboard
- (IBAction)resignAndLogin:(id)sender
{
    //  Get a reference to the text field on which the done button was pressed
    UITextField *tf = (UITextField *)sender;
    
    //  Check the tag. If this is the username field, then jump to the password field automatically
    if (tf.tag == 1) {
        
        [passwordField becomeFirstResponder];
        
        //  Otherwise we pressed done on the password field, and want to attempt login
    } else {
        
        //  First put away the keyboard
        [sender resignFirstResponder];
        
        //  Set up a predicate (or search criteria) for checking the username and password
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(username == %@ && password == %@)", [usernameField text], [passwordField text]];
        
        //  Actually run the query in Core Data and return the count of found users with these details
        //  Obviously if it found ANY then we got the username and password right!
        LRPUser *loginUser = nil;
        if ([CoreDataHelper countForEntity:@"User" withPredicate:pred andContext:[CoreDataHelper managedObjectContext]] > 0) {
            User* userLoggingIn = [[CoreDataHelper searchObjectsForEntity:@"User" withPredicate:pred andSortKey:@"username" andSortAscending:true andContext:[CoreDataHelper managedObjectContext]] objectAtIndex:0];
            
            //  We found a matching login user!  Force the segue transition to the next view
            loginUser = [[LRPUser alloc] initWithUser:userLoggingIn];
            
            [LRPAppState setCurrentUser:loginUser];

            // Load new root view from app delegate
            LRPAppDelegate *appDelegate = (LRPAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loginSuccessfull];
            
            [self dismissViewControllerAnimated:true completion:nil];
 //           [self performSegueWithIdentifier:@"LoginSegue" sender:sender];
            
        } else {
            //  We didn't find any matching login users. Wipe the password field to re-enter
            [passwordField setText:@""];
        }
        [LRPAppState setCurrentUser:loginUser]; // Update splitVC User
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 //   if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
 
 //   }

    
}





//  When the view reappears after logout we want to wipe the username and password fields
- (void)viewWillAppear:(BOOL)animated
{
    [usernameField setText:@""];
    [passwordField setText:@""];
    
    self.view.backgroundColor = [UIColor clearColor];
}





- (IBAction) createNewUser:(id)sender {

    LRPUser* newUser = [[LRPUser alloc] initWithName:[usernameField text] password:[passwordField text]];
    
    // To do - collect security questions
    
    if([CoreDataHelper createNewUserFromObject:newUser]) {
        // login new user automatically
        [self resignAndLogin:sender];
    } else {
        
        // ERROR CREATING USER - todo: send error message
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error - Failed to create user"
                              message:@"That username/password combination is invalid. Please try again."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [usernameField setText:@""];
        [passwordField setText:@""];
        
        NSLog(@"Error - Failed to create new user");

    }
/*
    // Check if username is taken
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(username == %@)", [usernameField text]];
    
    if ([CoreDataHelper countForEntity:@"User" withPredicate:pred andContext:[CoreDataHelper managedObjectContext]] <= 0) {
        NSManagedObject *cdNewUser = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
        
        [cdNewUser setValue:[usernameField text] forKey:@"username"];
        [cdNewUser setValue:[passwordField text] forKey:@"password"];
        
        [self resignAndLogin:sender];
    }
 */
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
    // make sure device has started sending orientation
    if(![[UIDevice currentDevice] orientation]) {
        // Start orientation calls
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }

    
    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        const int movementDistance = 120; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = 0;
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            movement = (!up ? -movementDistance : movementDistance);
        } else if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            movement = (up ? -movementDistance : movementDistance);
        }
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, movement, 0);
        [UIView commitAnimations];
    }
}




@end
