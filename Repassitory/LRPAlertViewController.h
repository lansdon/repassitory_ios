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
@property (strong, nonatomic) LRPAlertView* alertView;



//-(id)initWithView:(LRPAlertView*)view;
-(id)initWithTitle:(NSString*)title withMessage:(NSString*)message;

-(void)showAlertInViewController:(id)vc;
-(void)startActivityIndicator;
-(void)stopActivityIndicator;

- (void) addButtonWithTitle:(NSString*)t usingBlock:(void (^)(void))blockFunc;

- (void) addObserver:(id)observer selector:(NSString*)selectorName name:(NSString*)name object:(id)object;

- (void)setDismissNotificationName:(NSString*)notificationName;

-(void)dismissAlertWithCompletionBlock:(id) completion;


@end
