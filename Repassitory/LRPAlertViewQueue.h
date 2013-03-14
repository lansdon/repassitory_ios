//
//  LRPAlertViewController.h
//  Repassitory
//
//  Created by Lansdon Page on 3/13/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRPAlertView;


@interface LRPAlertViewQueue : NSObject

@property (nonatomic, strong) UIWindow* alertWindow;

-(id)init;
-(void)unload;
-(void)addAlert:(LRPAlertView*)alertView;
-(void)showAlert;
-(void)dismissAlert;


@end
