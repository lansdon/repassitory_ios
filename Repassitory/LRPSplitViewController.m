//
//  LRPSplitViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 1/20/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPSplitViewController.h"

#import "LRPAppState.h"
#import "LRPMasterViewController.h"
#import "LRPUser.h"
#import "MBProgressHUD.h"
#import "LRPAppDelegate.h"


@interface LRPSplitViewController ()
@property LRPAppDelegate* appDelegate;
//@property bool userLoaded;
@end

@implementation LRPSplitViewController
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
	
	// Register with delegate
	appDelegate = [(LRPAppDelegate*)[[UIApplication sharedApplication] delegate] registerViewController:self];
    
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor clearColor];
	

//	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"mastervc_did_load" object:nil];
/*
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"splitvc_did_load" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"loadUserRecords") name:@"detailvc_did_load" object:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:0.2
									 target:self
								   selector:@selector(postViewDidLoadNotification)
								   userInfo:nil
									repeats:NO];
 */
//	self.userLoaded = false;
//	self.splitvc_loaded = true;
	NSLog(@"Split - view did load");
}
/*
-(void)postViewDidLoadNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"splitvc_did_load" object:nil];	
}

*/

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
//	if(!self.userLoaded) {
//		[self loadUserRecords];
//	}
	NSLog(@"Split - view will appear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
