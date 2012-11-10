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
        rootNode = [MDTreeNode new];
    }

    return self;
}

- (void)removeItem:(MDTreeNode *)n
{
    [[rootNode children] removeObjectIdenticalTo:n];
}

- (NSArray *)allItems
{
    return [rootNode children];
}

- (MDTreeNode *)createItem
{
    MDTreeNode *n = [MDTreeNode new];
    
    [[rootNode children] insertObject:n atIndex:0];

    return n;
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to)
        return;

    MDTreeNode *n = [[rootNode children] objectAtIndex:from];
    [[rootNode children] removeObjectAtIndex:from];
    [[rootNode children] insertObject:n atIndex:to];
}

@end
