//
//  LRPUser.h
//  Repassitory
//
//  Created by Lansdon Page on 1/21/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRPUser : NSObject

@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *username;

- (id)init;

@end
