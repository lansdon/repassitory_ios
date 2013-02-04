//
//  LRPRecordDataController.h
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRPRecord;
@class LRPUser;

@interface LRPRecordDataController : NSObject

@property (nonatomic, copy) NSMutableArray* masterRecordList;

//- (id)initWithUser:(LRPUser*)currentUser;

- (NSUInteger)countOfList;

- (LRPRecord*)recordAtIndex:(NSUInteger)index;

- (void)addRecord:(LRPRecord*)record;

- (BOOL)loadUserRecordsFromContext;

@end
