//
//  MDTreeStore.h
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDTreeNode;

@interface MDTreeNodeStore : NSObject
{
    NSMutableArray *rootNodes;
}

+ (MDTreeNodeStore *) sharedStore;

- (NSArray *)allItems;
- (MDTreeNode *)createItem;

@end
