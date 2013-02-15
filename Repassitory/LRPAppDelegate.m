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
#import "CoreDataHelper.h"
#import "LRPAppState.h"



@implementation LRPAppDelegate

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Reset App State
    [LRPAppState reset];

    [CoreDataHelper managedObjectModel];    
    [CoreDataHelper persistentStoreCoordinator];
    [CoreDataHelper managedObjectContext];
        
    // Get a reference to the stardard user defaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Check if the app has run before by checking a key in user defaults
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
    
    // Get Login and Split View references
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPad"
                                                             bundle: nil];
    
    if(!self.loginVC) {
    self.loginVC = (LRPLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginVC"];
    }
    if(!self.splitVC) {
    self.splitVC = (LRPSplitViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"splitVC"];
    }
    
 // Load Login first
    [self.window setRootViewController:_loginVC];
    
    
    // Split Window optional loading for ipad/iphone
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [_splitVC.viewControllers lastObject];
        _splitVC.delegate = (id)navigationController.topViewController;
    }

    
    // Override point for customization after application launch.
    
    // Set background image for window
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];

    return YES;
}


// Unload login screen and load split view
- (void) loginSuccessfull {
    
    // remove old view
    [[[[self window ] subviews] objectAtIndex:0] removeFromSuperview];

    // Load User records into master view
    [self.splitVC.masterVC loadUserRecords];

    // add split view as new root controller
    [self.window setRootViewController:_splitVC];
    
    // ipad specific split view behavior
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UINavigationController *navigationController =
        [_splitVC.viewControllers lastObject];
        _splitVC.delegate = (id)navigationController.topViewController;
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [LRPAppState reset];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [LRPAppState reset];
    [_splitVC.detailVC setRecord:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    // Split Window optional loading for ipad/iphone
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }

    
    [LRPAppState reset];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [LRPAppState reset];
    // remove old view
//    [[[[self window ] subviews] objectAtIndex:0] removeFromSuperview];
    
    // Load Login first
    [self.window setRootViewController:_loginVC];

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



@end
