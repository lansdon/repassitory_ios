//
//  LRPSplitViewController.m
//  Repassitory
//
//  Created by Lansdon Page on 1/20/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPSplitViewController.h"

//#import "LRPUser.h"

@interface LRPSplitViewController ()

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
	// Do any additional setup after loading the view.
//    _user = [[LRPUser alloc] init];
    
    // opaque background exposes window image
    self.view.backgroundColor = [UIColor underPageBackgroundColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
