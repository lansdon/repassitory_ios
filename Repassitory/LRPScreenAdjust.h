//
//  LRPScreenAdjust.h
//  Repassitory
//
//  Created by Lansdon Page on 3/10/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRPScreenAdjust : NSObject

@property (nonatomic) NSInteger currentRow;
@property (nonatomic) UITableView* tableView;
@property (nonatomic) UIView* view;
@property (nonatomic) NSArray* views;
@property bool transitionActive;

-(LRPScreenAdjust*)initWithActiveViews:(NSArray*)views inContainingView:(UIView*)view inTable:(UITableView*)tableView;
-(void)viewBecameActive:(UIView*)view;
-(void)viewBecameInactive:(UIView*)view;
-(void)reset;


@end
