//
//  LRPSplitViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 1/20/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPSplitViewController.h"

#import "LRPAlertViewController.h"
#import "LRPAppState.h"
#import "LRPMasterViewController.h"
#import "LRPUser.h"
#import "MBProgressHUD.h"



@interface LRPSplitViewController ()
@property bool userLoaded;
@end

@implementation LRPSplitViewController

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
    
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor clearColor];
	

	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"mastervc_did_load" object:nil];
/*
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"splitvc_did_load" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"detailvc_did_load" object:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:0.2
									 target:self
								   selector:@selector(postViewDidLoadNotification)
								   userInfo:nil
									repeats:NO];
 */
	self.userLoaded = false;
//	self.splitvc_loaded = true;
	NSLog(@"Split - view did load");
}
/*
-(void)postViewDidLoadNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"splitvc_did_load" object:nil];	
}

*/

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:NO];
	
	if(!self.userLoaded) {
//		[self loadUserRecords];
	}
	NSLog(@"Split - view will appear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - User Functionality

/*
	This is the primary location for loading the user's records
	- Displays an activity alert while loading
 */
- (void)loadUserRecords {
	if(self.mastervc_loaded) {

		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.mode = MBProgressHUDModeIndeterminate;
		hud.labelText = [NSString stringWithFormat:@"Welcome back %@", [LRPAppState currentUser].username];
		hud.labelFont = [UIFont boldSystemFontOfSize:40];
		hud.detailsLabelText = @"Loading records...";
		hud.detailsLabelFont = [UIFont boldSystemFontOfSize:36];
		hud.minShowTime = 1.0;
		hud.dimBackground = true;
		
		dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			// Do something...
			[self.masterVC loadUserRecordsFromContext];
			[self setUserLoaded:true];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[MBProgressHUD hideHUDForView:self.view animated:YES];
				[self.masterVC reloadData];
			});
		});
	}
}



-(void)setUserLoginComplete:(bool)isLoggedIn {
	self.userLoaded = isLoggedIn;
}


@end
