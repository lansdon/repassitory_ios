//
//  LRPReocrdListViewController.h
//  Repassitory
//
//  Created by Lansdon Page on 1/17/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRPReocrdListViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *recordListData;

- (void)readDataForTable;

@end
