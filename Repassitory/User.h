//
//  User.h
//  Repassitory
//
//  Created by Lansdon Page on 1/29/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;

@end
