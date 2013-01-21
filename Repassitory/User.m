//
//  User.m
//  Repassitory
//
//  Created by Lansdon Page on 1/21/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic password;
@dynamic username;


-()init {
    self.username = @"";
    self.password = @"";
    
    return self;
}

@end
