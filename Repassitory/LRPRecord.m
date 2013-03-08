//
//  LRPRecord.m
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPRecord.h"
#import "LRPAppState.h"
#import "LRPUser.h"
#import "Record.h"

@implementation LRPRecord

-(id)initWithRecord:(Record*)sourceRecord {
	_title = sourceRecord.title;
	_username = sourceRecord.username;
	_password = sourceRecord.password;
	_url = sourceRecord.url;
	_updated = sourceRecord.updated;
	_notes = sourceRecord.notes;
	_user_id = [[LRPAppState currentUser] user_id];
	return self;
}

-(id)initWithTitle:(NSString*)title username:(NSString*)username password:(NSString*)password url:(NSString*)url notes:(NSString*)notes {
    
    if(self) {
        _title = title;
        _username = username;
        _password = password;
        _url = url;
        _updated = [[NSDate alloc] init];
        _notes = notes;
        _user_id = [[LRPAppState currentUser] user_id];
        
        return self;
    }
    return nil;
}


-(NSString*)getUpdateAsString {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	return [formatter stringFromDate:self.updated];
}

-(void) clear {
	_title = @"";
	_username = @"";
	_password = @"";
	_url = @"";
	_updated = [[NSDate alloc] init];
	_notes = @"";
	_user_id = [[LRPAppState currentUser] user_id];	
}



@end
