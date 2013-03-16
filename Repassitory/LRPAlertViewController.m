//
//  LRPViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 3/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAlertViewController.h"
#import "LRPAlertView.h"
#import "LRPAppDelegate.h"
//#import "LRPAlertViewQueue.m"


@interface LRPAlertViewController ()
@end

@implementation LRPAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTitle:(NSString*)title withMessage:(NSString*)message {
	if(self = [super init]) {
		self.alertView = [[LRPAlertView alloc] initWithTitle:title withMessage:message];
		self.view = self.alertView;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setDismissNotificationName:(NSString*)notificationName {
	void (^emptyBlock)(void) = ^(void) {
		NSLog(@"Empty Block");
		// add observer with nil for object seems to be instantiating a code block that's failing
	};
	
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAlertWithCompletionBlock:) name:notificationName object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAlertWithCompletionBlock:) name:notificationName object:nil];
}



#pragma mark - LRPAlertView Helper Functions

-(void)showAlertInViewController:(id)vc {
	if(!self.presentingViewController && ![self isBeingPresented]) {
//		LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];		
//		[[appDelegate.window rootViewController] presentViewController:self animated:YES completion:nil];
		if(vc) {
			NSLog(@"Showing alert %@ in vc=%@", self.alertView.title.text, vc);
//			[((UIViewController*)vc) addChildViewController:self];
//			[((UIViewController*)vc).view addSubview:self.view];

			[vc presentViewController:self animated:NO completion:nil];
			[self.alertView showAlert];
		}
	}
}

-(void)dismissAlertWithCompletionBlock:(id)completion {
	if(self.alertView) {
		[self.alertView dismissAlert];
	}
	
	if(self.presentingViewController) {
		NSLog(@"Dismiss alert %@ in vc=%@", self.alertView.title.text, self.presentingViewController);
//		[self.view removeFromSuperview];
//		[self removeFromParentViewController];
		NSLog(@"Mystery object is a %@", NSStringFromClass([completion class]));
		if([completion isKindOfClass:NSClassFromString(@"NSBlock")]) {
			[self.presentingViewController dismissViewControllerAnimated:false completion:completion];
		} else {
			[self.presentingViewController dismissViewControllerAnimated:false completion:nil];
		}
//		LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
//		if([[appDelegate.window rootViewController] presentedViewController] == self) {
//			[[appDelegate.window rootViewController] dismissViewControllerAnimated:NO completion:nil];
//		}		
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)startActivityIndicator {
	[self.alertView startActivityIndicator];
}
-(void)stopActivityIndicator {
	[self.alertView stopActivityIndicator];
}

/*
 addButtonWithTitle - helper function for lrpalertview subview
	(specifies a default block for dismissing the view controller on button press)
 */
- (void) addButtonWithTitle:(NSString*)t usingBlock:(void (^)(void))blockFunc {
	// Create dismiss block for default behavior or dismissing the alert
	if(!blockFunc) {
		blockFunc = ^(void) {
			[self dismissAlertWithCompletionBlock:nil];
		};
	}
	[self.alertView addButtonWithTitle:t usingBlock:blockFunc];
}

- (void) addObserver:(id)observer selector:(NSString*)selectorName name:(NSString*)name object:(id)object {
	[self.alertView addObserver:observer selector:selectorName name:name object:object];
}


@end
