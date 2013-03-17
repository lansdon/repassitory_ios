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
#import "LRPMasterViewController.h"
#import "LRPAlertView.h"
#import "LRPAppDelegate.h"

@interface LRPRecordDataController ()

@end


@implementation LRPRecordDataController

- (id)initWithMasterVC:(LRPMasterViewController*)masterVC {
    if(self = [super init]) {
		_masterVC = masterVC;
//		NSError *error;
		self.fetchedResultsController = [self fetchedResultsController];
//		if (![[self fetchedResultsController] performFetch:&error]) {
			// Update to handle the error appropriately.
//			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//			exit(-1);  // Fail
//		}
    }
    return self;
}



- (NSUInteger)countOfListInSection:(NSInteger)section {
    id  sectionInfo =
	[[_fetchedResultsController sections] objectAtIndex:section];    // using section 0
    return [sectionInfo numberOfObjects];
}



- (LRPRecord*)recordAtIndexPath:(NSIndexPath*)indexPath {
    if([self countOfListInSection:indexPath.section] > indexPath.row) {
		LRPRecord* result = [[LRPRecord alloc] initWithRecord:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		return result;
    } else {        
        NSLog(@"ERROR at viewing index=%d", indexPath.row);
        return nil;
    }
}


- (void) clearNewRecord {
	[self setCheckmarkForNewRecord:false];
	self.lastNewRecord = nil;
	self.lastNewRecordCell = nil;
}


- (void)addRecord:(LRPRecord*)record {
	NSLog(@"addRecord:%@", record.title);
	
	// Track which record was added last (for updating checkmarks and selected state)
	_lastNewRecord = record;

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
    
//	[self loadUserRecordsFromContext];
		
//	[self setCheckmarkForNewRecord:YES];
}




- (void) deleteRecord:(LRPRecord*)record {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(title == %@ && url == %@ && notes == %@ && updated == %@ && user_id == %@)", record.title, record.url, record.notes, record.updated, record.user_id];
	[CoreDataHelper deleteAllObjectsForEntity:@"Record" withPredicate:pred andContext:[CoreDataHelper managedObjectContext]];
	[CoreDataHelper saveContext];
	
//	[self loadUserRecordsFromContext];
}



- (BOOL)loadUserRecordsFromContext {
			
	// Reset FetchedResultsController
	self.fetchedResultsController = nil;	
	[NSFetchedResultsController deleteCacheWithName:@"Root"];
	
	// Build new Fetched Results Controller
	self.fetchedResultsController = [self fetchedResultsController];	
	
	// Execute the fetch request
	NSError *error = nil;
	BOOL success = [self.fetchedResultsController performFetch:&error];

	NSLog(@"Loading record for id: %@, count=%lu, success=%u", [LRPAppState currentUser].user_id, (unsigned long)[self countOfListInSection:0], success);

    return success;	
}



- (NSIndexPath*) getIndexForMatchingRecord: (LRPRecord*) inRecord {

	if([_fetchedResultsController fetchedObjects]) {
		for(int i=0; i<[self countOfListInSection:0]; ++i) {
			Record* fetchedObject = [_fetchedResultsController fetchedObjects][i];
			if([[fetchedObject title]	isEqualToString:inRecord.title] &&
			   [[fetchedObject username] isEqualToString:inRecord.username] &&
			   [[fetchedObject password] isEqualToString:inRecord.password] &&
			   //		   [fetchedObject isEqualToString:inRecord.url] &&
			   [[fetchedObject notes]	isEqualToString:inRecord.notes] &&
			   [fetchedObject user_id] == inRecord.user_id ) {
				return [NSIndexPath indexPathForRow:i inSection:0];
			}
		}
	}
	return nil; // error
}




#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
	
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"user_id == %d", [[LRPAppState currentUser].user_id intValue]];
		
    NSEntityDescription *entity = [NSEntityDescription
								   entityForName:@"Record" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    [fetchRequest setEntity:entity];
	[fetchRequest setPredicate:pred];
	
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
							  initWithKey:@"title" ascending:YES];
	
    [fetchRequest setSortDescriptors:[[NSArray alloc] initWithObjects:sort, nil]];
	
//    [fetchRequest setFetchBatchSize:20];
	
    NSFetchedResultsController *theFetchedResultsController =
	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
										managedObjectContext:[CoreDataHelper managedObjectContext]
										sectionNameKeyPath:nil
										cacheName:@"Root"];

	// Execute the fetch request
//	NSError *error = nil;
    
	self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
		
    return _fetchedResultsController;
}


- (void)setCheckmarkForNewRecord:(BOOL)isOn {
	NSLog(@"setCheckMark:%d", isOn);
	
	if(self.lastNewRecord) {
		NSIndexPath* indexPath = [self getIndexForMatchingRecord:self.lastNewRecord];

		if(isOn) {
			// scroll to new record
			[self.masterVC.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];

			// Highlight and checkmark
			self.lastNewRecordCell = [self.masterVC.tableView cellForRowAtIndexPath:indexPath];
			if(self.lastNewRecordCell) {
				self.lastNewRecordCell.accessoryType = UITableViewCellAccessoryCheckmark;
				[self.lastNewRecordCell setSelected:YES];
			}
		} else {
			self.lastNewRecordCell.accessoryType = UITableViewCellAccessoryNone;
			[self.lastNewRecordCell setSelected:NO];
		}
	}
//	[self.masterVC.view setNeedsDisplay];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Record *record = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = record.title;
	cell.accessoryType = UITableViewCellAccessoryNone;
	[cell setSelected:NO];

	// Configure Checkbox and highlighted
	if([[record title]	isEqualToString:self.lastNewRecord.title] &&
	   [[record username] isEqualToString:self.lastNewRecord.username] &&
	   [[record password] isEqualToString:self.lastNewRecord.password] &&
	   [[record notes]	isEqualToString:self.lastNewRecord.notes] &&
	   [record user_id] == self.lastNewRecord.user_id ) {
		_lastNewRecordCell = cell;
	}
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.masterVC.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = self.masterVC.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray
											   arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray
											   arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.masterVC.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.masterVC.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.masterVC.tableView endUpdates];
}





@end




