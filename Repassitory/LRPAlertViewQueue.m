//
//  LRPAlertViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 3/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAlertViewQueue.h"

#import "LRPAlertView.h"
#import "LRPAlertViewController.h"
#import "LRPAppDelegate.h"

// Alert View Options

@implementation LRPAlertViewQueue {
	NSMutableArray* alertViewQueue;
	bool alertOnDisplay;					// toggle if an alert is being shown
	
}

-(id)init {
	if([super init]) {
		alertViewQueue = [[NSMutableArray alloc] init];
		alertOnDisplay = false;
		if (self.alertWindow == nil)
		{
			CGRect screenBounds = [[UIScreen mainScreen] bounds];
			//		CGRect frame = view.frame;
			self.alertWindow = [[UIWindow alloc] initWithFrame:screenBounds];
			[self.alertWindow setBackgroundColor:[UIColor clearColor]];
			// Set background image for window
			self.alertWindow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
			//		[self.alertWindow setCenter:[[UIApplication sharedApplication] keyWindow].center];
			self.alertWindow.windowLevel = UIWindowLevelAlert;
			[self.alertWindow setAutoresizesSubviews:false];
		}
	}
	return self;
}


-(void)addAlert:(LRPAlertView*)alertView {
//	UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 210)];
//	[topView setBackgroundColor:[UIColor redColor]];
//	[topView addSubview:alertView];
	LRPAlertViewController* avController = [[LRPAlertViewController alloc] initWithTitle:@"FAIL" withMessage:@"FAIL"];
//	[avController.view setAutoresizesSubviews:false];
//	[avController.view setAutoresizingMask:UIViewAutoresizingNone];
//	avController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |
//	UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
//	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
//	if (![alertViewQueue containsObject:alertView] && alertViewQueue.count == 0) {
		if (alertViewQueue.count == 0) {
			[alertViewQueue addObject:avController];
			LRPAlertView* headView = (LRPAlertView*)[(LRPAlertViewController*)[alertViewQueue objectAtIndex:0] view];
			if(alertView == headView) {
				[self showAlert];
			}
		}
	//}
	[self update];
}


- (id) dequeueAlert {
	if(alertViewQueue.count) {
		id avController = [alertViewQueue objectAtIndex:0];
		if (avController != nil) {
			[alertViewQueue removeObjectAtIndex:0];
			return avController;
		}
	}
	return nil;
}



-(void)unload {
	// clear stuff here!
	
}

-(void)update {
	if(alertViewQueue.count) {
		LRPAlertViewController* avController = (LRPAlertViewController*)[alertViewQueue objectAtIndex:0];
		LRPAlertView* view = (LRPAlertView*)[avController view];
		if(view && [view superview]) {
//			[avController showAlertInViewController:nil];
		} else {
			[self dequeueAlert];
			[self update];
		}
/*
		[NSTimer scheduledTimerWithTimeInterval:0.5
										 target:self
									   selector:@selector(update)
									   userInfo:nil
										repeats:NO];
*/
	}
}

-(void)showAlert {
	LRPAlertViewController* avController = (LRPAlertViewController*)[alertViewQueue objectAtIndex:0];
//	LRPAlertView* view = (LRPAlertView*)[avController view];
	
	if (self.alertWindow == nil) {
		[self init];
	}
	

	[self.alertWindow setRootViewController:avController];
	[self.alertWindow makeKeyAndVisible];
//	LRPAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

}

-(void)dismissAlert {
	LRPAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
//	UIWindow *window = [appDelegate window];
	[(LRPAlertView*)self.alertWindow.rootViewController.view dismissAlert];
	[self.alertWindow setRootViewController:nil];
	[self.alertWindow setHidden:true];
	
	[appDelegate.window makeKeyAndVisible];
//	self.alertWindow = nil;
	[self dequeueAlert];
}

@end
