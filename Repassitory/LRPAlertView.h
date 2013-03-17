//
//  LRPAlertView.h
//  Repassitory
//
//  Created by Lansdon Page on 3/11/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRPAlertView : UIView

@property (retain, nonatomic) UIView* containerView;
@property (retain, nonatomic) UILabel* title;
@property (retain, nonatomic) UILabel* message;
@property (retain, nonatomic) UIActivityIndicatorView* activityIndicator;
@property (retain, nonatomic) NSMutableArray* buttons;
@property (retain, nonatomic) NSMutableArray* buttonBlocks;
@property (nonatomic) float dismissTimer;	// seconds until autodismiss
//@property UIAlertView* progressAlert;

- (id)initWithTitle:(NSString*)title withMessage:(NSString*)message;
- (void)showAlert;
- (void)dismissAlert;
- (NSInteger) addButtonWithTitle:(NSString*)t usingBlock:(void (^)(void))blockFunc;

- (void) addObserver:(id)observer selector:(NSString*)selectorName name:(NSString*)name object:(id)object;
- (void) onButtonPress: (id) sender;
- (void)startActivityIndicator;
- (void)stopActivityIndicator;
//- (void) displayMasterVC;


@end
