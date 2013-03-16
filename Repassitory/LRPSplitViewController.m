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
//#import "LRPRecordDataController.m"



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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"splitvc_did_load" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"detailvc_did_load" object:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:0.2
									 target:self
								   selector:@selector(postViewDidLoadNotification)
								   userInfo:nil
									repeats:NO];
	self.userLoaded = false;
	self.splitvc_loaded = true;
	NSLog(@"Split - view did load");
}

-(void)postViewDidLoadNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"splitvc_did_load" object:nil];	
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
//	self.userLoaded = false;
}

//-(void)viewDidDisappear:(BOOL)animated {
//	self.splitvc_loaded = false;
//	self.mastervc_loaded = false;
//	self.detailvc_loaded = false;
//}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:NO];
	
	if(!self.userLoaded) {
		[self loadUserRecords];
	}
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
	if(self.splitvc_loaded && self.mastervc_loaded && self.detailvc_loaded && !self.userLoaded) {
		
		if(!self.loadingAlertVC) {
			self.loadingAlertVC = [[LRPAlertViewController alloc]
								   initWithTitle: [NSString stringWithFormat:@"Record Vault(%@)", [LRPAppState currentUser].username]
								   withMessage:@"Retrieving records..."];
			[self.loadingAlertVC startActivityIndicator];
			[self.loadingAlertVC setDismissNotificationName:@"SplitVC_dismiss_loadingAlertVC"];
		}
		[self.loadingAlertVC showAlertInViewController:self.detailVC];

		[self performSelectorInBackground:NSSelectorFromString(@"_loadUserRecords") withObject:nil];
		self.userLoaded = true;
	}
}


/*
 background thread to load user records
 */
- (void)_loadUserRecords {
	[self.masterVC loadUserRecordsFromContext];

//	[self dismissLoadingAlert];
	[self performSelectorOnMainThread:@selector(dismissLoadingAlert) withObject:nil waitUntilDone:false];
}

-(void)dismissLoadingAlert {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SplitVC_dismiss_loadingAlertVC" object:self];
//	[self.detailVC lo
}

-(void)setUserLoginComplete:(bool)isLoggedIn {
	self.userLoaded = isLoggedIn;
}


@end
