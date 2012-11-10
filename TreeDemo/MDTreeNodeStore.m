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
        rootNode = [MDTreeNode new];
    
    return self;
}

- (void)removeItem:(MDTreeNode *)n
{
    MDTreeNode *parent = [n parent];

    // prevent deletion of the rootNode
    NSAssert(parent, @"MDTreeNodeStore's -removeItem: there was an attempt to \
             remove the root node");

    NSMutableArray *parentsChildren = [parent children];
    NSUInteger nodesIndexInParent =
        [parentsChildren indexOfObjectIdenticalTo:n];
    [parentsChildren removeObjectIdenticalTo:n];
    NSArray *childrenToReparent = [n children];
    __block NSMutableIndexSet *newIndexesOfChildrenToReparent =
        [NSMutableIndexSet indexSet];

    [childrenToReparent enumerateObjectsUsingBlock:^(id obj,
                                                     NSUInteger idx,
                                                     BOOL *stop)
    {
        [newIndexesOfChildrenToReparent addIndex:(nodesIndexInParent + idx)];

        [obj setParent:parent];
    }];

    [parentsChildren insertObjects:childrenToReparent
                         atIndexes:newIndexesOfChildrenToReparent];
}

- (NSArray *)allItems
{
    return [rootNode flatten];
}

- (MDTreeNode *)createItem
{
    MDTreeNode *n = [MDTreeNode new];

    [n setParent:rootNode];
    [[rootNode children] insertObject:n atIndex:0];

    return n;
}

- (MDTreeNode *)createChildIn:(MDTreeNode *)node
{
    return [self createChildIn:node atPosition:0];
}

- (MDTreeNode *)createChildIn:(MDTreeNode *)node
                   atPosition:(NSUInteger)position
{
    MDTreeNode *n = [MDTreeNode new];

    [n setParent:node];
    [[node children] insertObject:n atIndex:position];

    return n;
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to)
        return;

    NSArray *items = [self allItems];
    MDTreeNode *oldNode = [items objectAtIndex:from];
    MDTreeNode *targetNode = [items objectAtIndex:to];
    NSString *title = [oldNode title];
    MDTreeNode *newParent = [targetNode parent];
    NSUInteger targetPosition =
        [[newParent children] indexOfObjectIdenticalTo:targetNode];
    [self removeItem:oldNode];

    [[self createChildIn:newParent atPosition:targetPosition] setTitle: title];
}

@end
