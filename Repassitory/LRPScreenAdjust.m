        const float movementDuration = 0.3f; // tweak as needed
//
//  LRPScreenAdjust.m
//  Repassitory
//
//  Created by Lansdon Page on 3/10/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPScreenAdjust.h"

#import "LRPAppDelegate.h"


@interface LRPScreenAdjust () {
	
}
@property (nonatomic) UIView* currentView;
@end

@implementation LRPScreenAdjust

/*
	initWithActiveViews
		views - array of uiviews which can become first responders and which
				the screen is intended to be centered on. They should be tagged
				in order of appearance starting with tag '0'.
		inContainingView - This is the parent view containing all the subviews
		tableView(optional) - tableView holding the cells that are activated. This can be set to nil. If it is valid, the rows of the table will be highlighted when the subview of that row is activated.
 */
-(LRPScreenAdjust*)initWithActiveViews:(NSArray*)views inContainingView:(UIView*)view inTable:(UITableView*)tableView {
	
	self.currentRow = [(UIView*)[views objectAtIndex:0] tag];
	
	self.transitionActive = false;
	self.views = views;				// views which gain first responder
	self.tableView = tableView;		// Can be nil for non tableview
	self.view = view;

	// make sure device has started sending orientation
    if(![[UIDevice currentDevice] orientation]) {
        // Start orientation calls
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }

	return self;
}


-(void)viewBecameActive:(UIView*)view {
	self.currentView = view;

	NSInteger tag = view.tag;
	NSInteger adjust = tag - self.currentRow;
	self.currentRow += adjust;

	[self animateTextField:view];
}

-(void)viewBecameInactive:(UIView*)view {
	[self reset];
	
	NSInteger tag = view.tag;

	if(tag == [self.views count]-1) {	// last view in list
		[view resignFirstResponder];
		[self reset];
	}
	
	else if(tag < [self.views count] && tag >= 0) {
		UIView* nextView = [self getViewWithId:tag+1];
		
		if(nextView) {
			[nextView becomeFirstResponder];
		} else {
			[self reset];
		}
	}
	
}


-(UIView*)getViewWithId:(NSInteger)view_id {
	for(int i=0; i<[self.views count]; ++i) {
		NSInteger testTag = [[self.views objectAtIndex:i] tag];
		if(testTag  == view_id) {
			return [self.views objectAtIndex:i];
		}
	}
	return nil;
}


// Indicate whichi cells are active
-(void)setActiveCellByRow:(int)row forTableView:(UITableView*)tableView {
	NSArray* indexPaths = [tableView visibleCells];
	for(int i=0; i<[indexPaths count]; ++i) {
		UITableViewCell* cell = indexPaths[i];
		if(row == i) {
			[cell setBackgroundColor:[UIColor blueColor]];
//			[self setFirstResponderByTableRow:row];
		} else {
			[cell setBackgroundColor:[UIColor clearColor]];
		}
	}
}


-(id)getTopViewForView:(id)view {
	if(![view superview]) {
		return view;
	} else {
		return [self getTopViewForView:[view superview]];
	}
}

- (void) animateTextField:(UIView*)view
{
	[self reset];
	
	if(self.tableView) {
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
//		[self.tableView reloadData];
		[view setNeedsDisplay];
	}
	
	const float movementDuration = 0.3f; // tweak as needed
//	LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
//	id topView = [self getTopViewForView:view];
//	int screenHeight = self.view.frame.size.height;
		
//	NSLog(@"topview = %@", [topView class]);
	
	int targetHeight = [self getFocusHeight];    // center on view
//	int currentHeight = self.currentView.frame.size.height;
//	CGPoint convertedPoint = [view convertPoint:view.center toView:self.view];
	CGPoint convertedPoint = [view convertPoint:view.center toView:self.view];
	if(view.superview == self.view)
		convertedPoint = view.center;
	int viewHeightInWindow = convertedPoint.y;
	int movement = targetHeight - viewHeightInWindow;
	
	NSLog(@"scrn_adj - targetHeight = %d, viewHeight=%d, movement=%d", targetHeight, viewHeightInWindow, movement);

	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

	// Lansdcape or iPhone Portrait does adjustments
	if( UIDeviceOrientationIsLandscape(orientation) ||
	   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
		[self.view setNeedsDisplay];
		[view setNeedsDisplay];
        [UIView commitAnimations];
    }
}

/*
 ** Calculate display height where views are centered when the keyboard is up
 - ipad portrait - no effect
 - ipad landscape - center @ 25% height
 - iphone portrait - center @ 25% height
 - iphone landscape - center @ 25% height?
 */
-(int)getFocusHeight {
	const float DEF_HEIGHT_PERC = 0.35;   // 25% of screen height
	int screenHeight = self.view.bounds.size.height;
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if(UIDeviceOrientationIsLandscape(orientation)) {
//		int screenHeight = self.view.frame.size.width;
	}
	return screenHeight * DEF_HEIGHT_PERC;
	
/*
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return true;
	}
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return true;
	}
*/
}

// Set screen position back to default location
-(void)reset {
	[UIView beginAnimations: @"anim" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: 0.3];
	self.view.superview.frame = CGRectOffset(self.view.superview.frame, 0, 0);
	[UIView commitAnimations];
	
	self.currentRow = 0;
	self.currentView = nil;
}

@end
