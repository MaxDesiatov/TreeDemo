//
//  MDTreeStore.m
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeNodeStore.h"
#import "MDTreeNode.h"

@implementation MDTreeNodeStore

+ (MDTreeNodeStore *)sharedStore
{
    static MDTreeNodeStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];

    return sharedStore;
}

/** Enforcing Singleton pattern here as allocWithZone is called by alloc */
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        rootNodes = [NSMutableArray new];
    }

    return self;
}

- (NSArray *)allItems
{
    return rootNodes;
}

- (MDTreeNode *)createItem
{
    MDTreeNode *n = [MDTreeNode new];
    
    [rootNodes addObject:n];

    return n;
}

@end
