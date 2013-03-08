//
//  LRPRecordDataController.h
//  Repassitory
//
//  Created by Lansdon Page on 1/12/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//


#import <Foundation/Foundation.h>


@class LRPUser;
@class LRPRecord;
@class LRPMasterViewController;


@interface LRPRecordDataController : NSObject <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) LRPMasterViewController* masterVC;

//@property (nonatomic, copy) NSMutableArray* masterRecordList;
@property (retain, nonatomic) NSFetchedResultsController* fetchedResultsController;

- (id)initWithMasterVC:(LRPMasterViewController*)masterVC;

- (NSUInteger)countOfListInSection:(NSInteger)section;
//- (NSUInteger)countOfList;

- (LRPRecord*)recordAtIndexPath:(NSIndexPath*)indexPath;
//- (LRPRecord*)recordAtIndex:(NSUInteger)index;

- (void)addRecord:(LRPRecord*)record;

- (void) deleteRecord:(LRPRecord*)record;

- (BOOL)loadUserRecordsFromContext;

- (NSIndexPath*) getIndexForMatchingRecord: (LRPRecord*) inRecord;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
