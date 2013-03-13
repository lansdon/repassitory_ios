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
<UIAlertViewDelegate>
{
//    UIPickerView       *picker;
//    NSArray             *securityQuestions;
//	NSInteger securityQuestionIndex;
	
    bool usernameOK;
    bool password2OK;
    bool passwordOK;
	
	
//    bool securityAnswerOK;
//	bool securityQuestionOK;
}
@property (strong, nonatomic) IBOutlet UINavigationItem *saveButton;
//@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UITextField *usernameInput;
@property (strong, nonatomic) IBOutlet UILabel *usernameFeedback;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;
@property (strong, nonatomic) IBOutlet UILabel *passwordFeedback;
@property (strong, nonatomic) IBOutlet UITextField *password2Input;
@property (strong, nonatomic) IBOutlet UILabel *password2Feedback;
//@property (strong, nonatomic) IBOutlet UITextField *securityAnswerInput;
//@property (strong, nonatomic) IBOutlet UILabel *securityAnswerFeedback;
//@property (strong, nonatomic) IBOutlet UITextField *securityQuestionInput;
//@property (strong, nonatomic) IBOutlet UILabel *securityQuestionFeedback;

@property (nonatomic) LRPScreenAdjust* screenAdj;

@property (strong, nonatomic) NSArray *securityQuestions;
//-(IBAction)textFieldReturn:(id)sender;
-(IBAction)saveUser:(id)sender;
//-(IBAction)cancel:(id)sender;
-(bool)loginUser:(LRPUser*)user;

-(IBAction)validateUsername:(id)sender;
-(IBAction)validatePassword:(id)sender;
-(IBAction)validatePassword2:(id)sender;
//-(IBAction)validateSecurityAnswer:(id)sender;
-(void)updateSaveButton;
-(void)doConfirmDialogueWithTitle:(NSString*)title message:(NSString*)msg;
- (IBAction)textFieldDidExit:(UITextField *)textField;

@end
