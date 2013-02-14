//
//  LRPAppState.h
//  Repassitory
//
//  Created by Lansdon Page on 1/31/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRPUser;

@interface LRPAppState : NSObject

//@property (strong, nonatomic) User* currentUser;

// Get Currently Logged in User
+(LRPUser*)currentUser;

// Set Currently Logged in User
+(LRPUser*)setCurrentUser:(LRPUser*)newUser;

// Reset Current User
+(void)reset;

// Check for current user
+(bool)checkForUser;


@end
