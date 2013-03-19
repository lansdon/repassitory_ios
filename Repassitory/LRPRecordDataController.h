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
@class Record;
@class LRPMasterViewController;
@class LRPAlertView;

@interface LRPRecordDataController : NSObject <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) LRPMasterViewController* masterVC;
@property (retain, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic) LRPRecord* lastNewRecord;
@property (nonatomic) UITableViewCell* lastNewRecordCell;
@property (nonatomic) LRPAlertView* activityAlert;

- (id)initWithMasterVC:(LRPMasterViewController*)masterVC;

- (NSUInteger)countOfListInSection:(NSInteger)section;

- (LRPRecord*)recordAtIndexPath:(NSIndexPath*)indexPath;

- (void)addRecord:(LRPRecord*)record;
- (void)deleteRecord:(Record*)record;

- (BOOL)loadUserRecordsFromContext;

- (NSIndexPath*) getIndexForMatchingRecord: (LRPRecord*) inRecord;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)setCheckmarkForNewRecord:(BOOL)isOn;

- (void) clearNewRecord;

@end
