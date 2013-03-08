//
//  LRPRecord.h
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Record;

@interface LRPRecord : NSObject


@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSDate* updated;
@property (strong, nonatomic) NSString* notes;
@property (strong, nonatomic) NSNumber* user_id;

//@property (strong, nonatomic) NSMutableString* category;
// ID ??

-(id)initWithRecord:(Record*)sourceRecord;

-(id)initWithTitle:(NSString*)title username:(NSString*)username password:(NSString*)password url:(NSString*)url notes:(NSString*)notes;

// Converts stored date format into displayable string
-(NSString*)getUpdateAsString;
//-(NSString*)getSearchableUsername;
//-(NSString*)getSearchablePassword;

-(void) clear;

@end
