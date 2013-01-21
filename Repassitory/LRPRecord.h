//
//  LRPRecord.h
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRPRecord : NSObject


@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSURL* url;
@property (strong, nonatomic) NSDate* date;
//@property (strong, nonatomic) NSMutableString* category;
// ID ??

-(id)initWithTitle:(NSString*)title username:(NSString*)username password:(NSString*)password url:(NSURL*)url;

@end
