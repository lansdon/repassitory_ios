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

@implementation LRPRecord

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




@end
