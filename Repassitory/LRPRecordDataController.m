//
//  LRPRecordDataController.m
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPRecordDataController.h"
#import "LRPRecord.h"

@interface LRPRecordDataController ()

-(void)initializeDefaultDataList;

@end


@implementation LRPRecordDataController

- (id)init {
    if(self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (void)initializeDefaultDataList {
    NSMutableArray* records = [[NSMutableArray alloc] init];
    self.masterRecordList = records;
    LRPRecord* record = [[LRPRecord alloc] initWithTitle:@"Title" username:@"name1" password:@"pass" url:(NSURL*)[NSURL URLWithString:@"WWW.STUFF.COM"]];
    
    [self addRecord:record];
}

- (void)setMasterRecordList:(NSMutableArray *)newList {
    if(_masterRecordList != newList) {
        _masterRecordList = [newList mutableCopy];
    }
}

- (NSUInteger)countOfList {
    return [self.masterRecordList count];
}

- (LRPRecord*)recordAtIndex:(NSUInteger)index {
    return [self.masterRecordList objectAtIndex:index];
}

- (void)addRecord:(LRPRecord*)record {
    [self.masterRecordList addObject:record];
}

@end
