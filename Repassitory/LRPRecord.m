//
//  LRPRecord.m
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPRecord.h"

@implementation LRPRecord

-(id)initWithTitle:(NSString*)title username:(NSString*)username password:(NSString*)password url:(NSString*)url notes:(NSString*)notes {
    
    if(self) {
        _title = title;
        _username = username;
        _password = password;
        _url = url;
        _date = [[NSDate alloc] init];
        _notes = notes;
        
        return self;
    }
    return nil;
}




@end
