//
//  MDTreeNode.h
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDTreeNode : NSObject

@property (copy) NSMutableString *title;
@property (strong) NSMutableArray *children;
@property (weak) MDTreeNode *parent;
@property (assign) NSUInteger left;
@property (assign) NSUInteger right;
@property (assign) BOOL isExpanded;

@end
