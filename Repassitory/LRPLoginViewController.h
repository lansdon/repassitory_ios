//
//  LRPLoginViewController.h
//  Repassitory
//
//  Created by Lansdon Page on 1/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRPLoginViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end