//
//  LRPAlertViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 3/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAlertViewController.h"

#import "LRPAlertView.h"

// Alert View Options

@implementation LRPAlertViewController {
	NSMutableArray* alertViewQueue;
	bool alertOnDisplay;					// toggle if an alert is being shown
	
}

-(id)init {
	if([super init]) {
		alertViewQueue = [[NSMutableArray alloc] init];
		alertOnDisplay = false;
	}
	return self;
}


-(void)addAlert:(LRPAlertView*)alertView {
	if (![alertViewQueue containsObject:alertView] && alertViewQueue.count == 0) {
		[alertViewQueue addObject:alertView];
		if(alertView == [alertViewQueue objectAtIndex:0]) {
			[alertView showAlert];
		}
	}
	[self update];
}


- (id) dequeueAlert {
    // if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
    id headObject = [alertViewQueue objectAtIndex:0];
    if (headObject != nil) {
		
//        [headObject retain]; // so it isn't dealloc'ed on remove
        [alertViewQueue removeObjectAtIndex:0];
    }
    return headObject;
}



-(void)unload {
	// clear stuff here!
	
}

-(void)update {
	if(alertViewQueue.count) {
		LRPAlertView* head = [alertViewQueue objectAtIndex:0];
		if(head && [head superview]) {
			[head showAlert];
		} else {
			[self dequeueAlert];
			[self update];
		}
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(update)
									   userInfo:nil
										repeats:NO];
	}
}

@end
