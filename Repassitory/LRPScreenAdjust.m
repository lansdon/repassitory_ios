//
//  LRPScreenAdjust.m
//  Repassitory
//
//  Created by Lansdon Page on 3/10/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPScreenAdjust.h"

@implementation LRPScreenAdjust

/*
	initWithActiveViews
		views - array of uiviews which can become first responders and which
				the screen is intended to be centered on. They should be tagged
				in order of appearance starting with tag '0'.
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
	NSInteger tag = view.tag;
	NSInteger adjust = tag - self.currentRow;
	self.currentRow += adjust;
	
	[self animateTextField:view up:YES numberOfMoves:adjust];
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




- (void) animateTextField:(UIView*)view up:(BOOL)up numberOfMoves:(NSInteger)moves
{
//	if(moves == 0) moves = 1; // don't multiply by zero

	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		
	if(orientation == UIInterfaceOrientationLandscapeRight ||
	   orientation == UIInterfaceOrientationLandscapeLeft) {
//	if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        const int movementDistance = 60; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        int movement = 0;
		movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement*moves);
        [UIView commitAnimations];
    }
}


// Set screen position back to default location
-(void)reset {
	[UIView beginAnimations: @"anim" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: 0.3];
	self.view.superview.frame = CGRectOffset(self.view.superview.frame, 0, 0);
	[UIView commitAnimations];
	
	self.currentRow = 0;
}

@end
