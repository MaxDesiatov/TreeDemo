//
//  MDTreeNode.h
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDTreeNode : NSObject

@property (copy) NSString *title;
@property (strong) NSMutableArray *children;
@property (weak) MDTreeNode *parent;
@property (assign) NSUInteger left;
@property (assign) NSUInteger right;
@property (assign) BOOL isExpanded;

- (NSArray *)flatten;

@end
