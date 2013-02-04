//
//  LRPAppDelegate.m
//  Repassitory
//
//  Created by Lansdon Page on 1/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAppDelegate.h"

#import "LRPLoginViewController.h"
#import "User.h"
#import "CoreDataHelper.h"
#import "LRPAppState.h"



@implementation LRPAppDelegate

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    LRPLoginViewController *rootView = (LRPLoginViewController *)self.window.rootViewController;
//    NSManagedObjectModel* _managedObjectModel =
    [CoreDataHelper managedObjectModel];
    
//    NSPersistentStoreCoordinator* _persistentStoreCoordinator =
    [CoreDataHelper persistentStoreCoordinator];

//    NSManagedObjectContext* _managedObjectContext =
    [CoreDataHelper managedObjectContext];
    
//    rootView.managedObjectContext = _managedObjectContext;
//    rootView.persistentStoreCoordinator = _persistentStoreCoordinator;
//    rootView.managedObjectModel = _managedObjectModel;
    
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
        
        // Commit to core data
        NSError *error;
        if (![[CoreDataHelper managedObjectContext] save:&error])
            NSLog(@"Failed to add default user with error: %@", [error domain]);
        }
    
    // Reset App State
    [LRPAppState reset];

    // Split Window optional loading for ipad/iphone
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }

    
    //   self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    _loginViewController = [[LRPLoginViewController alloc] init];
    
//    [self.window setRootViewController:_loginViewController];

//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    
//    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
//     _loginViewController = (LRPLoginViewController *)self.window.rootViewController;

    return YES;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [LRPAppState reset];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [LRPAppState reset];
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
