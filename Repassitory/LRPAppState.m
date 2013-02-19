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


static NSString* _key = nil;            // Static variable for user key


@implementation LRPAppState

// PROGRAM VERSION
+(NSString*) getVersion {
	
	return @"0.5.0";
}

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
    
    [LRPAppState setKey:@"default2"];
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
    if(_key != newKey) {
        _key = newKey;
    }
}

+(NSString*)getKey {
    if(!_key) {
        _key = @"default";
    }
    
    // Validation
    if([LRPAppState checkForUser]) {
        _key = [LRPAppState currentUser].password;
    } else {
        // No current user means we're hoping the key was set properly during new user creation
    }
    return _key;
}


+(void) showAppInfo {
	
	NSString* aboutMsg = [[NSString alloc] initWithFormat:
						  @"Repassitory\n"
						  "Version %@\n"
						  "By Lansdon Page\n"
						  "Copyright 2013\n"
						  "\n"
						  "Repassitory is a password database where you can store "
						  "your passwords in one spot. You'll never lose those annoying, "
						  "infrequently used passwords again!\n"
						  ""
						  "Security: Repassitory uses a powerful AES encryption algorithm "
						  "in combination with Apple's Core Data storage technology. This means "
						  "your information is stored on your device in a secure encrypted format "
						  "that only YOU can get to!", [LRPAppState getVersion]];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithFrame:CGRectMake(0, 0, 400, 750)];
	alert.frame = CGRectMake(0, 0, 300, 800);
	[alert autoresizesSubviews];
	[alert setFrame:CGRectMake(0, 0, 300, 300)];
	[alert setTitle:@"About Repassitory"];
	[alert setMessage:aboutMsg];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"OK"];
	[alert show];
	
}


@end
