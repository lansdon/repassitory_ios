//
//  LRPViewController.h
//  Repassitory
//
//  Created by Lansdon Page on 3/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRPAlertView;

@interface LRPAlertViewController : UIViewController
- (id) initWithView:(LRPAlertView*)view;

-(void)showAlert;
@end
