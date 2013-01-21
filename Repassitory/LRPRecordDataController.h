//
//  LRPRecordDataController.h
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRPRecord;

@interface LRPRecordDataController : NSObject

@property (nonatomic, copy) NSMutableArray* masterRecordList;

- (NSUInteger)countOfList;

- (LRPRecord*)recordAtIndex:(NSUInteger)index;

- (void)addRecord:(LRPRecord*)record;



@end
