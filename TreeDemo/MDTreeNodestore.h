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
    MDTreeNode *rootNode;
}

+ (MDTreeNodeStore *) sharedStore;

- (void)removeItem:(MDTreeNode *)n;
- (NSArray *)allItems;
- (MDTreeNode *)createItem;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;

@end
