//
//  LRPUser.m
//  Repassitory
//
//  Created by Lansdon Page on 1/21/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPUser.h"
#import "User.h"



@implementation LRPUser

//@synthesize _username;

- (id) init {
    _username = @"";
    _password = @"";
    _user_id = [NSNumber numberWithInt:-1];
    _security_answer = @"";
    _security_question = [NSNumber numberWithInt:-1];    
    return self;
}

-(id)initWithName:(NSString*)name password:(NSString*)password {
    _username = name;
    _password = password;
    _user_id = [NSNumber numberWithInt:-1];
    _security_answer = @"";
    _security_question = [NSNumber numberWithInt:-1];
    return self;
}


- (id)initWithUser:(User*)sourceUser {
    [self setValue:sourceUser.username forKey:@"username"];
    [self setValue:sourceUser.password forKey:@"password"];
    [self setValue:sourceUser.security_question forKey:@"security_question"];
    [self setValue:sourceUser.security_answer forKey:@"security_answer"];
    [self setValue:sourceUser.user_id forKey:@"user_id"];
    return self;
}

@end
