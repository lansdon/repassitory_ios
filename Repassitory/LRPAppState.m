//
//  LRPAppState.m
//  Repassitory
//
//  Created by Lansdon Page on 1/31/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPAppState.h"
#import "LRPUser.h"
#import "MBAlertView.h"
#import "Record.h"

@interface LRPAppState ()

@end


//static NSString* _key = nil;            // Static variable for user key


@implementation LRPAppState


#pragma mark - Version
// PROGRAM VERSION
+(NSString*) getVersion {
	return @"0.8.1";
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
	
	MBAlertView *alert = [MBAlertView alertWithBody:aboutMsg cancelTitle:@"OK" cancelBlock:nil];
	
	if([self isIphone]) {
		alert.bodyFont = [UIFont systemFontOfSize:14];
	} else {
		
	}
	
	[alert addToDisplayQueue];
	
}



#pragma mark - Current User

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
/*
+(void)setKey:(NSString*)newKey { // User creation must manually set the key prior to db activity.
    if(_key != newKey) {
        _key = newKey;
    }
}
*/
+(NSString*)getKeyForUser:(LRPUser*)user {
	NSString* key = [[NSString alloc] init];
    if(user) {
        key = [NSString stringWithFormat:@"%@%@",[LRPAppState currentUser].username, [LRPAppState currentUser].password];
    } else {
        key = @"default";
    }
    return key;
}


+(NSString*)getKey {
    return [self getKeyForUser:[self currentUser]];
}


#pragma mark - Device Type Helpers


+(bool) isIpad {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return true;
	}
	return false;
}

+(bool) isIphone {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return true;
	}
	return false;
}




#pragma mark - Current Record
/*
// Current record for display on detail view
+(Record*)currentRecord:(Record*)newRecord {
    static Record* currentRecord = nil;
	
	// Check for optional new record
    if(newRecord) {
        currentRecord = newRecord;
    }
    return currentRecord;
}
*/
/*
+(void)setCurrentRecord:(Record*)record {
//	[LRPAppState currentRecord] = record;
    [[LRPAppState currentRecord] setTitle:record.title];
    [[LRPAppState currentRecord] setUpdated:record.updated];
    [[LRPAppState currentRecord] setUsername:record.username];
    [[LRPAppState currentRecord] setPassword:record.password];
    [[LRPAppState currentRecord] setUser_id:record.user_id];
    [[LRPAppState currentRecord] setUrl:record.url];
    [[LRPAppState currentRecord] setNotes:record.notes];
    
}
*/

@end
