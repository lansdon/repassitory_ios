//
//  LRPUser.h
//  Repassitory
//
//  Created by Lansdon Page on 1/21/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface LRPUser : NSObject

@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* username;
@property (nonatomic) NSNumber* user_id;
@property (nonatomic, retain) NSString* security_answer;
@property (nonatomic) NSNumber* security_question;

- (id)init;
- (id)initWithName:(NSString*)name password:(NSString*)password;

- (id)initWithUser:(User*)sourceUser;


@end
