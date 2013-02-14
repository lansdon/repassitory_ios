//
//  LRPRecordDataController.m
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPRecordDataController.h"
#import "Record.h"
#import "LRPRecord.h"
#import "LRPUser.h"
#import "CoreDataHelper.h"
#import "LRPAppState.h"

@interface LRPRecordDataController ()

//-(void)initializeDefaultDataList;

@end


@implementation LRPRecordDataController

- (id)init {
    if(self = [super init]) {
        _masterRecordList = [[NSMutableArray alloc] init];
//        if(![[LRPAppState currentUser].username isEqualToString:@""]) {
            // TEMP - ADD Dummy first entry
//            int count = [CoreDataHelper countForEntity:@"Record" andContext:[CoreDataHelper managedObjectContext]];
//            if(!count) {
//                [self initializeDefaultDataList];
//            }

            // Load Core Data Records into local array sorted by title
//            self.masterRecordList = [CoreDataHelper getObjectsForEntity:@"Record" withSortKey:@"title" andSortAscending:true andContext:[CoreDataHelper managedObjectContext]];
            return self;
//        }
    }
    return nil;
}



//- (void)initializeDefaultDataList {
//    NSMutableArray* records = [[NSMutableArray alloc] init];
//    self.masterRecordList = records;
    
//    LRPRecord* record = [[LRPRecord alloc] initWithTitle:@"Title" username:@"name1" password:@"pass" url:@"WWW.STUFF.COM" notes:@"notes"];
    
//    [self addRecord:record];
//}

- (void)setMasterRecordList:(NSMutableArray *)newList {
    if(_masterRecordList != newList) {
        _masterRecordList = [newList mutableCopy];
    }
}

- (NSUInteger)countOfList {
    return [self.masterRecordList count];
}

- (LRPRecord*)recordAtIndex:(NSUInteger)index {
    if([self.masterRecordList count] > index) {
        return [self.masterRecordList objectAtIndex:index];
    }
    else {
        
        NSLog(@"ERROR at viewing index=%d", index);
        return nil;
    }
}

- (void)addRecord:(LRPRecord*)record {    
    // create new record in core data and fill with passed values
    NSManagedObject *cdNewRecord = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:[CoreDataHelper managedObjectContext]];

    [cdNewRecord setValue:record.title forKey:@"title"];
    [cdNewRecord setValue:record.username forKey:@"username"];
    [cdNewRecord setValue:record.password forKey:@"password"];
    [cdNewRecord setValue:record.url forKey:@"url"];
    [cdNewRecord setValue:record.updated forKey:@"updated"];
    [cdNewRecord setValue:record.notes forKey:@"notes"];
    [cdNewRecord setValue:record.user_id forKey:@"user_id"];
    
    [CoreDataHelper saveContext];

    [self loadUserRecordsFromContext];
}




- (BOOL)loadUserRecordsFromContext {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"user_id == %d", [[LRPAppState currentUser].user_id intValue]];

    NSMutableArray* tempList = [CoreDataHelper searchObjectsForEntity:@"Record" withPredicate:pred andSortKey:@"title" andSortAscending:true andContext:[CoreDataHelper managedObjectContext]];
    
    // Clear existing records if we have valid input
//    if(tempList.count) {
        [_masterRecordList removeAllObjects];
//    }
    
    // Loop through array and convert to LRPUser objects
    NSEnumerator *e = [tempList objectEnumerator];
    Record *record;
    
    while (record = [e nextObject]) {
        // convert core data User to LRPUser and add to array
        LRPRecord* temp = [LRPRecord alloc];
        temp.title = record.title;
        temp.username = record.username;
        temp.password = record.password;
        temp.url = record.url;
        [temp setUpdated: record.updated];
        temp.notes = record.notes;
        temp.user_id = record.user_id;
        [_masterRecordList addObject:temp];
    }
//    [self setMasterRecordList:[CoreDataHelper getObjectsForEntity:@"Record" withSortKey:@"title" andSortAscending:true andContext:[CoreDataHelper managedObjectContext]]];
    return true;
}


@end




