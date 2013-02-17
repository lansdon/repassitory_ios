//
//  LRPAppState.m
//  Repassitory
//
//  Created by Lansdon Page on 1/31/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAppState.h"
#import "LRPUser.h"

@interface LRPAppState ()

@end

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
    [[LRPAppState currentUser] setUser_id:newUser.user_id];
    [[LRPAppState currentUser] setSecurity_question:newUser.security_question];
    [[LRPAppState currentUser] setSecurity_answer:newUser.security_answer];
    
    return [LRPAppState currentUser];
}

// Reset Current User
+(void)reset {
    [[LRPAppState currentUser] setUsername:@""];
    [[LRPAppState currentUser] setPassword:@""];
    [[LRPAppState currentUser] setUser_id:[NSNumber numberWithInt:-2]];
    [[LRPAppState currentUser] setSecurity_question:[NSNumber numberWithInt:-2]];
    [[LRPAppState currentUser] setSecurity_answer:@""];
    
    [LRPAppState setKey:@""];
}



// Check for current user
+(bool)checkForUser {
    if ([[[LRPAppState currentUser] username] isEqualToString:@""] ||
        [[[LRPAppState currentUser] password] isEqualToString:@""] ||
        ![LRPAppState currentUser]) {
        return false;
    }
    return true;
}

#pragma mark - Encryption Keys

+(void)setKey:(NSString*)newKey { // User creation must manually set the key prior to db activity.
    NSString* key = [LRPAppState getKey];
    key = newKey;
}

+(NSString*)getKey {
    static NSString* key = nil;
    if(!key) {
        key = [[NSString alloc]init];
    }
    
    // Validation
    if([LRPAppState checkForUser]) {
        key = [LRPAppState currentUser].password;
    } else {
        // No current user means we're hoping the key was set properly during new user creation
    }
    return key;
}


@end
