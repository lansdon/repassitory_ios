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
#import "MBProgressHUD.h"


@interface LRPAppDelegate ()
@property bool userLoaded;
@end

@implementation LRPAppDelegate



#pragma mark - Application Lifetime

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//
	// General Initialization (not device specific)
	//
	
    // Initialize Core Data
    [CoreDataHelper managedObjectModel];    
    [CoreDataHelper persistentStoreCoordinator];
    [CoreDataHelper managedObjectContext];

    // Set background image for window
	self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"mastervc_did_load" object:nil];
	
	//
	// IPHONE SPECIFIC
	//
	if([LRPAppState isIphone]) {
		UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle: nil];
		if(!self.loginNavC) {
			self.loginNavC = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginNavController"];
		}
		if(!self.loginVC) {
			self.loginVC = (LRPLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginVC"];
		}
		if(!self.phoneRecordsNav) {
			self.phoneRecordsNav = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"phoneRecordsNav"];
		}
		if(!self.detailVC) {
			self.detailVC = (LRPDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"detailVC"];
		}
		if(!self.masterVC) {
			self.masterVC = (LRPMasterViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"masterVC"];
		}
	}
	
	
	//
	// IPAD SPECIFIC
	//
	else if([LRPAppState isIpad]) {
		UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPad" bundle: nil];
		if(!self.loginNavC) {
			self.loginNavC = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginNavController"];
		}
		
		if(!self.loginVC) {
			self.loginVC = (LRPLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginVC"];
		}
		if(!self.splitVC) {
			self.splitVC = (LRPSplitViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"splitVC"];
		}
		
        UINavigationController *navigationController = [_splitVC.viewControllers lastObject];
        _splitVC.delegate = (id)navigationController.topViewController;
		
	}
	
	// Load Login first
    [self.window setRootViewController:self.loginNavC];

    // Start orientation calls
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    return YES;
}




- (void)applicationUnload {
	// Remove views (we want to always come back on the login screen)
//	for(int i = [[[self window] subviews] count]; i > 0; --i) {
//		[[[[self window ] subviews] objectAtIndex:i-1] removeFromSuperview];
//	}
//	[self.alertQueue unload];
//	self.alertQueue = nil;
	
	// Set login view controller to top level view
	[self.loginNavC popToRootViewControllerAnimated:YES];
	
    // Reset App State (current user, etc)
	[LRPAppState reset];
	
	// Reset the detail view so records aren't partially visible when reloading app
    self.currentRecord = nil;
	self.userLoaded = false;
	
	_splitVC = nil;
	_phoneRecordsNav = nil;
	_masterVC = nil;	// required to trigger reloading of records

	[self.window setRootViewController:nil];

}

- (void)applicationLoad {
    
	//
	// General Initialization (not device specific)
	//
	[LRPAppState reset]; // redundant but safe
	self.userLoaded = false;
	
    // Initialize Core Data
    [CoreDataHelper managedObjectModel];
    [CoreDataHelper persistentStoreCoordinator];
    [CoreDataHelper managedObjectContext];
	
    // Set background image for window
	self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];

	
	//
	// IPHONE SPECIFIC
	//
	if([LRPAppState isIphone]) {
		self.alertFontTitle = [UIFont fontWithName:@"Copperplate" size:24];
		self.alertFontBody = [UIFont fontWithName:@"Copperplate" size:18];
		
		UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle: nil];
		
		if(!self.loginNavC) {
			self.loginNavC = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginNavController"];
		}
		if(!self.loginVC) {
			self.loginVC = (LRPLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginVC"];
		}
		if(!self.phoneRecordsNav) {
			self.phoneRecordsNav = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"phoneRecordsNav"];
		}
		if(!self.masterVC) {
			self.masterVC = (LRPMasterViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"masterVC"];
		}
		if(!self.detailVC) {
			self.detailVC = (LRPDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"detailVC"];
		}
	}
	
	
	//
	// IPAD SPECIFIC
	//
	else if([LRPAppState isIpad]) {

		self.alertFontTitle = [UIFont fontWithName:@"Copperplate" size:40];
		self.alertFontBody = [UIFont fontWithName:@"Copperplate" size:36];

		UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPad" bundle: nil];

		if(!self.loginNavC) {
			self.loginNavC = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginNavController"];
		}
		if(!self.loginVC) {
			self.loginVC = (LRPLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginVC"];
		}
		if(!self.splitVC) {
			self.splitVC = (LRPSplitViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"splitVC"];
		}		
        UINavigationController *navigationController = [_splitVC.viewControllers lastObject];
        _splitVC.delegate = (id)navigationController.topViewController;
		
	}
	
	// Load Login first
//	[self.loginNavC popToRootViewControllerAnimated:YES];
    [self.window setRootViewController:self.loginNavC];
	
    // Start orientation calls
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		
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



#pragma mark - User Functions

/*
	openRecords
	- When a user has successfully logged in, we remove the start/login view controllers
	 and switch to split screen root view controller for presenting records
 */
- (void) openRecords {
	// reset user login bool
	[self setUserLoginComplete:false];
	
	// remove old views
	for(int i = [[[self window] subviews] count]; i > 0; --i) {
		[[[[self window ] subviews] objectAtIndex:i-1] removeFromSuperview];
	}
	
	
    // --- Switch to master/detail screens -- //
	
	// iPad
	if([LRPAppState isIpad]) {
		if(_splitVC) {
			[self.window setRootViewController:_splitVC];
			UINavigationController *navigationController =
			[_splitVC.viewControllers lastObject];
			_splitVC.delegate = (id)navigationController.topViewController;
		}
	}
	
	// iPhone
	else if([LRPAppState isIphone]) {
		[self.window setRootViewController:self.phoneRecordsNav];
	}
	
	// Load user records here just in case master view is still in memory
	if(self.mastervc_loaded) {
		[self loadUserRecords];
	}
}

#pragma mark - User Functionality

/*
 This is the primary location for loading the user's records
 - Displays an activity alert while loading
 */
- (void)loadUserRecords {
	if(self.mastervc_loaded && !self.userLoaded) {
		
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
		hud.mode = MBProgressHUDModeIndeterminate;
		hud.labelText = [NSString stringWithFormat:@"Hello %@", [LRPAppState currentUser].username];
		hud.labelFont = self.alertFontTitle;
		hud.detailsLabelText = @"Loading records...";
		hud.detailsLabelFont = self.alertFontBody;
		hud.minShowTime = 1.0;
		hud.dimBackground = true;

		[self setUserLoaded:true];
		dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			// Do something...
			[self.masterVC loadUserRecordsFromContext];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[MBProgressHUD hideHUDForView:self.window animated:YES];
				[self.masterVC reloadData];
			});
		});
	}
}



-(void)setUserLoginComplete:(bool)isLoggedIn {
	self.userLoaded = isLoggedIn;
}


#pragma mark - Register View Controller
- (id)registerViewController:(id)viewController {
	
	if([viewController isKindOfClass:[LRPSplitViewController class]]) {
		self.splitVC = viewController;
	}
	else if([viewController isKindOfClass:[LRPDetailViewController class]]) {
		self.detailVC = viewController;
	}
	if([viewController isKindOfClass:[LRPMasterViewController class]]) {
		self.masterVC = viewController;
	}
	if([viewController isKindOfClass:[LRPLoginViewController class]]) {
		self.loginVC = viewController;
	}
	return self;
}



@end
