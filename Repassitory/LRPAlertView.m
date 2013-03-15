//
//  LRPAlertView.m
//  Repassitory
//
//  Created by Lansdon Page on 3/11/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAlertView.h"

#import "LRPAppDelegate.h"
#import "LRPAlertViewQueue.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

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

    if (self = [super init]) {
		float viewWidth = 400.0;
		float viewHeight = 210.0;
		float viewWidthMultiplier = 0.70; // percent of screen width = view width
		float viewHeightMultiplier = 0.25; // percent of screen width = view width
		float subviewWidthMultiplier = 0.90; // percent of screen width = view width
		int titleFontSize = 36;
		int messageFontSize = 32;
//		int buttonFontSize = 30;
		self.dismissTimer = 0.0;	// seconds until auto dismiss
		
		if(!self.buttons) self.buttons = [[NSMutableArray alloc] init];
		if(!self.buttonBlocks) self.buttonBlocks = [[NSMutableArray alloc] init];

		LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
		UIWindow *window = appDelegate.alertQueue.alertWindow;
		
		// Container Window Dimensions + location
//        CGRect screenBounds = [[UIScreen mainScreen] bounds];
		
		self.bounds = CGRectMake(0,0, window.frame.size.width, window.frame.size.height);
//		self.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
		// container box
		self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
		[self centerViews];
//		self.containerView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

		//		self.frame = CGRectMake(0, 0, window.frame.size.width*viewWidthMultiplier, window.frame.size.height*viewHeightMultiplier);
//		self.center = window.center;
//		[self setAutoresizesSubviews:false];
		[self setContentMode:UIViewContentModeCenter];
//		[self setAutoresizingMask:UIViewAutoresizingNone];
		self.containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		// Subview Dimensions + Locations
		self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width*subviewWidthMultiplier, self.containerView.frame.size.height*0.15)];
		self.message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width*subviewWidthMultiplier, self.containerView.frame.size.height*0.4)];
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		[self.title setCenter:CGPointMake(self.containerView.bounds.size.width*.5, self.containerView.bounds.size.height*.15)];
		[self.message setCenter:CGPointMake(self.containerView.bounds.size.width*.5, self.containerView.bounds.size.height*.4)];
		[self.activityIndicator setCenter:CGPointMake(self.containerView.bounds.size.width*.5, self.containerView.bounds.size.height*.6)];
		
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
		[self.containerView addSubview:self.title];
		[self.containerView addSubview:self.message];
		[self.containerView addSubview:self.activityIndicator];
		[self addSubview:self.containerView];
		
		// Background Colors
		[self setBackgroundColor:[UIColor clearColor]];
		[self.containerView setBackgroundColor:[UIColor blackColor]];
		[self.title setBackgroundColor:[UIColor clearColor]];
		[self.message setBackgroundColor:[UIColor clearColor]];
		
		// configure buttons
		[self configureButtons];
		
		// Respond to orientation changes
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
	}
	return self;
}


-(void)configureButtons {
	// configure buttons
	for(int i=0; i<self.buttons.count; ++i) {
		UIButton* b = [self.buttons objectAtIndex:i];
		[self.containerView addSubview:b];
		[b setHidden:NO];
		[b setFrame:CGRectMake(0, 0, self.containerView.frame.size.width/(self.buttons.count+1.5), self.containerView.frame.size.height*.15)];
		
		[b setCenter:CGPointMake(self.containerView.frame.size.width/(self.buttons.count+1)*(i+1), self.containerView.frame.size.height*.85)];
		b.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:30];
		[b setNeedsDisplay];
	}
	
}
/*
-(BOOL)shouldAutorotate
{
    return YES;
}
*/

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

// Centers the container view to the middle of the superview
- (void) centerViews {
	LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
	UIWindow *window = appDelegate.alertQueue.alertWindow;

	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//	if(UIInterfaceOrientationIsLandscape(orientation)) {
//	if(orientation == UIInterfaceOrientationLandscapeRight ||
//	   orientation == UIInterfaceOrientationLandscapeLeft) {
		self.containerView.center = CGPointMake(self.bounds.size.width/2+self.bounds.origin.x, self.bounds.size.height/2+self.bounds.origin.y);
		
//	} else {
//		self.containerView.center = CGPointMake(self.bounds.size.height/2, self.bounds.size.width/2);
//	}


}


-(void)showAlert
{
	LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
	UIWindow *window = appDelegate.alertQueue.alertWindow;
	
//	[self centerViews];
	
    self.title.hidden = NO;
    self.message.hidden = NO;
	
//    self.activityIndicator.contentMode = UIViewContentModeCenter;

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
	[self.containerView addSubview:self.activityIndicator];
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
//	[self removeFromSuperview];
	[[NSNotificationCenter defaultCenter] removeObserver:self];

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
		LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate dismissALert];
//		[self dismissAlert];
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
	if(_buttons.count) {
		int buttonIndex = [_buttons indexOfObjectIdenticalTo: sender];
		void (^blockFunc)(void) = [self.buttonBlocks objectAtIndex:buttonIndex];
		if(blockFunc != NULL) {
			blockFunc();
			//		[self performSelectorOnMainThread: withObject:nil waitUntilDone:NO ];
		}
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


//UIDeviceOrientation currentOrientation;

- (void)deviceOrientationDidChange:(NSNotification *)notification {

//	[self centerViews];
		
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object:nil];
	
//	[self performSelector:@selector(rotateOrientationInDegrees) withObject:nil afterDelay:0];
}



/*
-(void) rotateOrientationInDegrees {
	enum degrees {UIDeviceOrientationLandscapeLeft=-90,
					UIDeviceOrientationPortrait=0,
					UIDeviceOrientationLandscapeRight=90,
					UIDeviceOrientationPortraitUpsideDown=180};
	
	//Obtaining the current device orientation
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	float newAngle = 0.0;
	if (orientation == UIDeviceOrientationPortrait) {
		newAngle = 0.0;
	}
	else if (orientation == UIDeviceOrientationLandscapeRight) {
		newAngle = -90.0;
	}
	else if (orientation == UIDeviceOrientationLandscapeLeft) {
		newAngle = 90.0;
	}
	else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		newAngle = 180.0;
	}

	
	currentOrientation = orientation;
//	[self initWithTitle:self.title.text withMessage:self.message.text];
//	[self showAlert];
//	[self ]
	[UIView beginAnimations:@"rotate" context:nil];
	[UIView setAnimationDuration:0.5];
	self.transform = CGAffineTransformIdentity;
	self.transform = CGAffineTransformMakeRotation(DegreesToRadians(newAngle));
	[UIView commitAnimations];
}
 
 */
 
@end
