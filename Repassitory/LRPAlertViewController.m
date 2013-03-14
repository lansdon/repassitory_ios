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

- (id) initWithView:(LRPAlertView*)view {
	if(self = [super init]) {
		self.view = view;
		
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


-(void)showAlert {
//	id appDelegate = [[UIApplication sharedApplication] delegate];
//	UIWindow *window = [appDelegate window];
//	[window addSubview:self.view];

	
//	[appDelegate presentViewController:self animated:true completion:nil];
	[(LRPAlertView*)self.view showAlert];
}

-(void)dismissAlert {
	LRPAppDelegate* appDelegate = (LRPAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate dismissALert];
//	[(LRPAlertView*)self.view dismissAlert];
//	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
