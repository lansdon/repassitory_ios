//
//  LRPAppDelegate.m
//  Repassitory
//
//  Created by Lansdon Page on 1/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAppDelegate.h"

#import "LRPLoginViewController.h"
#import "LRPSplitViewController.h"
#import "LRPMasterViewController.h"
#import "LRPDetailViewController.h"
#import "User.h"
#import "LRPUser.h"
#import "CoreDataHelper.h"
#import "LRPAppState.h"
#import "LRPAlertViewQueue.h"
#import "LRPAlertView.h"
#import "LRPAlertViewController.h"


@implementation LRPAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Reset App State
//    [LRPAppState reset];

    // Initialize Core Data
    [CoreDataHelper managedObjectModel];    
    [CoreDataHelper persistentStoreCoordinator];
    [CoreDataHelper managedObjectContext];
    
	self.alertQueue = [[LRPAlertViewQueue alloc] init];
	
    // Get a reference to the stardard user defaults
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Check if the app has run before by checking a key in user defaults
/*
    if ([prefs boolForKey:@"hasRunBefore"] != YES)
    {
        // Set flag so we know not to run this next time
        [prefs setBool:YES forKey:@"hasRunBefore"];
        [prefs synchronize];
        
        // Add our default user object in Core Data
        User *user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
        [user setUsername:@"admin"];
        [user setPassword:@"password"];
        [user setSecurity_question:[NSNumber numberWithInt:1]];
        [user setUser_id:[NSNumber numberWithInt:1]];
        
        // Commit to core data
        NSError *error;
        if (![[CoreDataHelper managedObjectContext] save:&error])
            NSLog(@"Failed to add default user with error: %@", [error domain]);
        }
*/
    // Get Login and Split View references
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPad"
                                                             bundle: nil];
	if(!self.loginNavC) {
        self.loginNavC = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginNavController"];
	}
    
    if(!self.loginVC) {
        self.loginVC = (LRPLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginVC"];
    }
    if(!self.splitVC) {
        self.splitVC = (LRPSplitViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"splitVC"];
    }
    
 // Load Login first
    [self.window setRootViewController:self.loginNavC];
    
    
    // Split Window optional loading for ipad/iphone
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UINavigationController *navigationController = [_splitVC.viewControllers lastObject];
        _splitVC.delegate = (id)navigationController.topViewController;
    }

    // Set background image for window
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    
    // Start orientation calls
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    return YES;
}


// Unload login screen and load split view
- (void) loginSuccessfull {
	self.loginAlert= [[LRPAlertView alloc] initWithTitle:@"Logging in..." withMessage:[NSString stringWithFormat:@"Retrieving records for %@",[LRPAppState currentUser].username]];
	
//	[self.loginAlert addObserver:self selector:@"startLogin" name:@"startLogin" object:nil];
	[self.loginAlert addObserver:self selector:@"stopLogin" name:@"stopLogin" object:nil];
	[self.loginAlert startAnimating];
	

	// remove old views
	for(int i = [[[self window] subviews] count]; i > 0; --i) {
		[[[[self window ] subviews] objectAtIndex:i-1] removeFromSuperview];
	}
	
	[self addAlert:self.loginAlert];
    
	// Load in different thread
	[self performSelectorInBackground:@selector(doLogin) withObject:nil];

}

//-(void)startLogin {
//	[self.loginAlert startAnimating];
//}

-(void)stopLogin {
//	[self.loginAlert dismissAlert];
//	id appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
//	LRPAlertView* view = (LRPAlertView*)[appDelegate presentedViewController].view;
	
//	[view dismissAlert];
//	 [appDelegate dismissViewControllerAnimated:true completion:nil];
	[self.alertQueue dismissAlert];
}

- (void) doLogin {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"startLogin" object:self];
	
//	for(int i = [[[self window] subviews] count]; i > 0; --i) {
//		[[[[self window ] subviews] objectAtIndex:i-1] removeFromSuperview];
//	}
	
	[self.loginAlert showAlert];
	
    // add split view as new root controller
    [self.window setRootViewController:_splitVC];
    
    // ipad specific split view behavior
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UINavigationController *navigationController =
        [_splitVC.viewControllers lastObject];
        _splitVC.delegate = (id)navigationController.topViewController;
    }
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopLogin" object:self];
    
}

- (void)applicationUnload {
	// Remove views (we want to always come back on the login screen)
//	for(int i = [[[self window] subviews] count]; i > 0; --i) {
//		[[[[self window ] subviews] objectAtIndex:i-1] removeFromSuperview];
//	}
	[self.alertQueue unload];
	self.alertQueue = nil;
	
	// Set login view controller to top level view
	[self.loginNavC popToRootViewControllerAnimated:YES];
	
    // Reset App State (current user, etc)
	[LRPAppState reset];
	
	// Reset the detail view so records aren't partially visible when reloading app
    [_splitVC.detailVC setRecord:nil];

	[self.window setRootViewController:nil];

}

- (void)applicationLoad {
	self.alertQueue = [[LRPAlertViewQueue alloc] init];
    
	[LRPAppState reset]; // redundant but safe

	// Load Login first
	[self.loginNavC popToRootViewControllerAnimated:YES];
    [self.window setRootViewController:self.loginNavC];
	
}

	
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	[self applicationUnload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[self applicationUnload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    // Split Window optional loading for ipad/iphone
    // Override point for customization after application launch.
/*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
*/
	[self applicationLoad];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

	[self applicationLoad];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [LRPAppState reset];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Alert View

- (void)addAlert:(LRPAlertView*)alert {
	[self.alertQueue addAlert:alert];
}

- (void)dismissALert {
	[self.alertQueue dismissAlert];
}



@end
