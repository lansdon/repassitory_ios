//
//  LRPAlertView.m
//  Repassitory
//
//  Created by Lansdon Page on 3/11/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAlertView.h"

@implementation LRPAlertView {
	NSMutableArray* observers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString*)title withMessage:(NSString*)message
{
    self = [super init];
    if (self) {
		float viewWidthMultiplier = 0.70; // percent of screen width = view width
		float viewHeightMultiplier = 0.25; // percent of screen width = view width
		float subviewWidthMultiplier = 0.90; // percent of screen width = view width
		int titleFontSize = 36;
		int messageFontSize = 32;
//		int buttonFontSize = 30;
		self.dismissTimer = 0.0;	// seconds until auto dismiss
		
		self.buttons = [[NSMutableArray alloc] init];
		self.buttonBlocks = [[NSMutableArray alloc] init];

		id appDelegate = [[UIApplication sharedApplication] delegate];
		UIWindow *window = [appDelegate window];
//		[window addSubview:self];
		
		// Container Window Dimensions + location
		self.frame = CGRectMake(0, 0, window.frame.size.width*viewWidthMultiplier, window.frame.size.height*viewHeightMultiplier);
		self.center = window.center;
		
		// Subview Dimensions + Locations
		self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*subviewWidthMultiplier, self.frame.size.height*0.15)];
		self.message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*subviewWidthMultiplier, self.frame.size.height*0.4)];
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		[self.title setCenter:CGPointMake(self.frame.size.width*.5, self.frame.size.height*.15)];
		[self.message setCenter:CGPointMake(self.frame.size.width*.5, self.frame.size.height*.4)];
		[self.activityIndicator setCenter:CGPointMake(self.frame.size.width*.5, self.frame.size.height*.6)];
		
		// Text Properties
		[self.title setFont:[UIFont fontWithName:@"ArialMT" size:titleFontSize]];
		[self.message setFont:[UIFont fontWithName:@"ArialMT" size:messageFontSize]];
		[self.title setTextAlignment:NSTextAlignmentCenter];
		[self.message setTextAlignment:NSTextAlignmentCenter];
		[self.title setTextColor:[UIColor blueColor]];
		[self.message setTextColor:[UIColor blueColor]];
		
		// Assign Text
		[self.title setText:title];
		[self.message setText:message];
		
		// Add subviews to container view
		[self addSubview:self.title];
		[self addSubview:self.message];
		[self addSubview:self.activityIndicator];
		
		// Background Colors
		[self setBackgroundColor:[UIColor blackColor]];
		[self.title setBackgroundColor:[UIColor clearColor]];
		[self.message setBackgroundColor:[UIColor clearColor]];
		
		// configure buttons
		[self configureButtons];
	}
	return self;
}


-(void)configureButtons {
	// configure buttons
	for(int i=0; i<self.buttons.count; ++i) {
		UIButton* b = [self.buttons objectAtIndex:i];
		[self addSubview:b];
		[b setHidden:NO];
		[b setFrame:CGRectMake(0, 0, self.frame.size.width/(self.buttons.count+1.5), self.frame.size.height*.15)];
		
		[b setCenter:CGPointMake(self.frame.size.width/(self.buttons.count+1)*(i+1), self.frame.size.height*.85)];
		b.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:30];
		[b setNeedsDisplay];
	}
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)updateView {
	[self.title setNeedsDisplay];
	[self.message setNeedsDisplay];
	[self.activityIndicator setNeedsDisplay];
//	[self configureButtons];
	[self setNeedsDisplay];
}

-(void)showAlertWithTimer:(float)seconds {
	self.dismissTimer = seconds;
	[self showAlert];
}

-(void)showAlert
{
	id appDelegate = [[UIApplication sharedApplication] delegate];
	UIWindow *window = [appDelegate window];
	[window addSubview:self];

    self.title.hidden = NO;
    self.message.hidden = NO;
//    self.activityIndicator.hidden = YES;
//	[self startAnimating];
	
    self.activityIndicator.contentMode = UIViewContentModeCenter;

	[self updateView];

	if(self.dismissTimer >= 0.1) {
		[NSTimer scheduledTimerWithTimeInterval:self.dismissTimer
										 target:self
									   selector:@selector(dismissAlert)
									   userInfo:nil
										repeats:NO];
	}
}

-(void)startAnimating {
	[self.activityIndicator setHidden:NO];
	[self.activityIndicator startAnimating];
	[self.activityIndicator setNeedsDisplay];
	[self addSubview:self.activityIndicator];
	[self bringSubviewToFront:self.activityIndicator];
	[self updateView];

}

-(void)stopAnimating {
	[self.activityIndicator setHidden:YES];
	[self.activityIndicator stopAnimating];
	[self.activityIndicator removeFromSuperview];
	[self updateView];

}

-(void)dismissAlert
{
//    [UIView beginAnimations:nil context:nil];
//    self.alpha = 0.0;
	[self removeFromSuperview];
	[self removeAllObservers];
//    [UIView commitAnimations];
}


- (NSInteger) addButtonWithTitle:(NSString*)t usingBlock:(void (^)(void))blockFunc
{
	UIButton* b = [UIButton buttonWithType: UIButtonTypeCustom];
	[b setTitle: t forState: UIControlStateNormal];
	[b setFrame:CGRectMake(0, 0, 200, 50)];
	
	[b setBackgroundColor:[UIColor darkGrayColor]];
	[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	
//	UIImage* buttonBgNormal = [UIImage imageNamed: @"TSAlertViewButtonBackground.png"];
//	buttonBgNormal = [buttonBgNormal stretchableImageWithLeftCapWidth: buttonBgNormal.size.width / 2.0 topCapHeight: buttonBgNormal.size.height / 2.0];
//	[b setBackgroundImage: buttonBgNormal forState: UIControlStateNormal];
	
//	UIImage* buttonBgPressed = [UIImage imageNamed: @"TSAlertViewButtonBackground_Highlighted.png"];
//	buttonBgPressed = [buttonBgPressed stretchableImageWithLeftCapWidth: buttonBgPressed.size.width / 2.0 topCapHeight: buttonBgPressed.size.height / 2.0];
//	[b setBackgroundImage: buttonBgPressed forState: UIControlStateHighlighted];
	
	[b addTarget: self action: @selector(onButtonPress:) forControlEvents: UIControlEventTouchUpInside];
	
	[self.buttons addObject: b];
	
	void (^defCancelBlock)(void) = ^(void) {
		[self dismissAlert];
	};
	
	if(blockFunc == nil) {
		[self.buttonBlocks addObject: defCancelBlock];
	} else {
		[self.buttonBlocks addObject:[blockFunc copy]];
	}

	[self configureButtons];
	
	return self.buttons.count-1;
}

	
- (void) onButtonPress: (id) sender
{
	int buttonIndex = [_buttons indexOfObjectIdenticalTo: sender];
	void (^blockFunc)(void) = [self.buttonBlocks objectAtIndex:buttonIndex];
	if(blockFunc != NULL) {
		blockFunc();
		//		[self performSelectorOnMainThread: withObject:nil waitUntilDone:NO ];
	}
//	else {
//		[self dismissAlertMethod];
//	}
	
//	if ( [self.delegate respondsToSelector: @selector(alertView:clickedButtonAtIndex:)] )
//	{
//		[self.delegate alertView: self clickedButtonAtIndex: buttonIndex ];
//	}
	
//	if ( buttonIndex == self.cancelButtonIndex )
//	{
//		if ( [self.delegate respondsToSelector: @selector(alertViewCancel:)] )
//		{
//			[self.delegate alertViewCancel: self ];
//		}
//	}
	
//	[self dismissWithClickedButtonIndex: buttonIndex  animated: YES];
}


- (void) addObserver:(id)observer selector:(NSString*)selectorName name:(NSString*)name object:(id)object {
	NSMutableArray* observerObj = [[NSMutableArray alloc] init];
	[observerObj addObject: (observer ? : [NSNull null])];
	[observerObj addObject: (selectorName ? : [NSNull null])];
	[observerObj addObject: (name ? : [NSNull null])];
	[observerObj addObject: (object ? : [NSNull null])];
	
	[observers addObject:observerObj];
	
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:NSSelectorFromString(selectorName) name:name object:object];
}

-(void) removeAllObservers {
	for(int i=0; i < observers.count; ++i) {
		NSMutableArray* observer = [observers objectAtIndex:i];
		[[NSNotificationCenter defaultCenter] removeObserver:[observer objectAtIndex:0] name:[observer objectAtIndex:2] object:[observer objectAtIndex:3]];
	}
}

@end
