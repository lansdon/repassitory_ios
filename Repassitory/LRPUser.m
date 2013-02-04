//
//  LRPUser.m
//  Repassitory
//
//  Created by Lansdon Page on 1/21/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPUser.h"



@implementation LRPUser

//@synthesize _username;

- (id) init {
    _password = @"";
    _username = @"";
    return self;
}

-(id)initWithName:(NSString*)name password:(NSString*)password {
    _password = name;
    _username = password;
    return self;
}

@end
