//
//  LRPAppState.h
//  Repassitory
//
//  Created by Lansdon Page on 1/31/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRPUser;
@class Record;

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

// Encryption Keys
+(NSString*)getKeyForUser:(LRPUser*)user;
+(NSString*)getKey;

+(NSString*) getVersion;

+(void) showAppInfo;

// Check if this is iphone or ipad
+(bool) isIpad;
+(bool) isIphone;


// Current record for display on detail view
//+(Record*)currentRecord:(Record*)newRecord;


//+(void)setCurrentRecord:(Record*)record;

@end
