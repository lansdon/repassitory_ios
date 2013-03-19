//
//  Record.m
//  Repassitory
//
//  Created by Lansdon Page on 2/5/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "Record.h"


@implementation Record

@dynamic notes;
@dynamic password;
@dynamic title;
@dynamic updated;
@dynamic url;
@dynamic username;
@dynamic user_id;

-(NSString*)getUpdateAsString {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	return [formatter stringFromDate:self.updated];
}


@end
