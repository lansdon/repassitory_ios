//
//  User.h
//  Repassitory
//
//  Created by Lansdon Page on 2/3/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * id;

@end
