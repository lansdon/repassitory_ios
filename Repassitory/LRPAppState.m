//
//  LRPAppState.m
//  Repassitory
//
//  Created by Lansdon Page on 1/31/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAppState.h"
#import "LRPUser.h"

@implementation LRPAppState

// Get Currently Logged in User
+(LRPUser*)currentUser {
    static LRPUser* currentUser = nil;
    if(!currentUser) {
        currentUser = [[LRPUser alloc] init];
    }
    return currentUser;
}

// Set Currently Logged in User
+(LRPUser*)setCurrentUser:(LRPUser*)newUser {
    [[LRPAppState currentUser] setUsername:newUser.username];
    [[LRPAppState currentUser] setPassword:newUser.password];
    
    return [LRPAppState currentUser];
}

// Reset Current User
+(void)reset {
    [[LRPAppState currentUser] setUsername:@""];
    [[LRPAppState currentUser] setPassword:@""];
}

@end
