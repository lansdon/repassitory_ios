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
#import "LRPAppState.h"

@interface LRPLoginViewController ()
- (IBAction)resignAndLogin:(id)sender;
@end

@implementation LRPLoginViewController

@synthesize usernameField, passwordField;


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
            
            //  We found a matching login user!  Force the segue transition to the next view
            loginUser = [[LRPUser alloc] initWithName:[usernameField text] password:[passwordField text]];
            
            [LRPAppState setCurrentUser:loginUser];
            [CoreDataHelper loadUserStore:loginUser];   // load db into context
 //           [self.splitVC.masterVC.dataController lo]
            
            [self dismissViewControllerAnimated:true completion:nil];
 //           [self performSegueWithIdentifier:@"LoginSegue" sender:sender];
            
        } else {
            //  We didn't find any matching login users. Wipe the password field to re-enter
            [passwordField setText:@""];
        }
        [LRPAppState setCurrentUser:loginUser]; // Update splitVC User
    }
}


/*
- (NSPersistentStoreCoordinator *)getUserStore:(NSString*)username password:(NSString*) password;
{
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    NSString *userStr = [NSString stringWithFormat:@"%@%@.sqlite", username, password];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:
                       userStr];
    
    NSError *error = nil;
    //    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
 
        //        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
*/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
 
        // Set managed object on Split View
//        LRPSplitViewController* splitVC = [segue destinationViewController];
//        splitVC.managedObjectContext = self.managedObjectContext;

        // Split Window optional loading for ipad/iphone
        // Override point for customization after application launch.
 //       if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//                    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//                    UINavigationController *navigationController = [splitVC.viewControllers lastObject];
//                    splitVC.delegate = (id)navigationController.topViewController;
//        }

    }

    
}





//  When the view reappears after logout we want to wipe the username and password fields
- (void)viewWillAppear:(BOOL)animated
{
    [usernameField setText:@""];
    [passwordField setText:@""];
    
}



@end
