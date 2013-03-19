//
//  LRPNewUserViewController.h
//  Repassitory
//
//  Created by Lansdon Page on 2/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRPUser;
@class LRPScreenAdjust;

@interface LRPNewUserViewController : UITableViewController
{	
    bool usernameOK;
    bool password2OK;
    bool passwordOK;
}

@property (strong, nonatomic) IBOutlet UINavigationItem *saveButton;
@property (strong, nonatomic) IBOutlet UITextField *usernameInput;
@property (strong, nonatomic) IBOutlet UILabel *usernameFeedback;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;
@property (strong, nonatomic) IBOutlet UILabel *passwordFeedback;
@property (strong, nonatomic) IBOutlet UITextField *password2Input;
@property (strong, nonatomic) IBOutlet UILabel *password2Feedback;
@property (nonatomic) LRPScreenAdjust* screenAdj;

@property (strong, nonatomic) NSArray *securityQuestions;
-(IBAction)saveUser:(id)sender;
-(bool)loginUser:(LRPUser*)user;

-(IBAction)validateUsername:(id)sender;
-(IBAction)validatePassword:(id)sender;
-(IBAction)validatePassword2:(id)sender;
-(void)updateSaveButton;
- (IBAction)textFieldDidExit:(UITextField *)textField;

@end
