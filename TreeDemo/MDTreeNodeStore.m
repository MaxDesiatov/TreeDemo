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
//    const int oldCount = [[self allItems] count];
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

//    NSArray *newItems = [self allItems];
//    const int newCount = [[self allItems] count];
//    NSUInteger indexOfRemovedItem = [newItems indexOfObjectIdenticalTo:n];
//    NSAssert((newCount == oldCount - 1) && indexOfRemovedItem == NSNotFound,
//             @"broken invariants in MDTreeNodeStore's -removeItem");
}

- (void)removeItemWithChildren:(MDTreeNode *)n
{
    
}

- (NSArray *)allItems
{
    return [rootNode flatten];
}

- (MDTreeNode *)createItem
{
//    const int oldCount = [[self allItems] count];
    MDTreeNode *n = [MDTreeNode new];

    [n setParent:rootNode];
    [[rootNode children] insertObject:n atIndex:0];

//    const int newCount = [[self allItems] count];
//    NSAssert(newCount == oldCount + 1,
//             @"broken invariant in MDTreeNodeStore's -createItem");

    return n;
}

- (MDTreeNode *)createChildIn:(MDTreeNode *)node
{
//    const int oldCount = [[self allItems] count];
    MDTreeNode *newChild = [self createChildIn:node atPosition:0];

//    const int newCount = [[self allItems] count];
//    NSAssert((newCount == oldCount + 1) && ([newChild parent] == node),
//             @"broken invariant in MDTreeNodeStore's -createChildIn");

    return newChild;
}

- (MDTreeNode *)createChildIn:(MDTreeNode *)node
                   atPosition:(NSUInteger)position
{
//    const int oldCount = [[self allItems] count];
    MDTreeNode *newChild = [MDTreeNode new];

    [newChild setParent:node];

    NSLog(@"-createChildIn invoked to create at position %d in array of size \
%d", position, [[node children] count]);
    NSMutableArray *children = [node children];
    if ([children count] < position)
        [children addObject:newChild];
    else
        [children insertObject:newChild atIndex:position];

//    const int newCount = [[self allItems] count];
//    NSAssert((newCount == oldCount + 1) &&
//                ([newChild parent] == node) &&
//                ([[[newChild parent] children] indexOfObjectIdenticalTo:newChild] ==
//                    position),
//             @"broken invariant in MDTreeNodeStore's -createChildIn:atPosition:");

    return newChild;
}

- (void)moveItemAtRow:(int)from toIndex:(int)to
{
    if (from == to)
        return;

    NSLog(@"-moveItemAtRow invoked to move from row %d to row %d", from, to);
    NSArray *items = [self allItems];
    MDTreeNode *oldNode = [items objectAtIndex:from];
    MDTreeNode *targetNode =
        [items count] > to ? [items objectAtIndex:to] : nil;

    NSString *title = [oldNode title];
    MDTreeNode *newParent = targetNode ? [targetNode parent] : rootNode;
    if (newParent == oldNode)
        newParent = rootNode;
    
    NSUInteger newParentRow =
        newParent == rootNode ? 0 : [items indexOfObjectIdenticalTo:newParent];
    NSLog(@"-moveItemAtRow: newParentRow is %d and newParent has %d children",
          newParentRow, [[newParent children] count]);
        
    [self removeItem:oldNode];

    int childCount = [[newParent children] count];
    int positionToPut = (to - newParentRow);

    NSLog(@"-moveItemAtRow: local index is %d, the index of the last clild is %d",
          positionToPut, childCount - 1);

    [[self createChildIn:newParent
              atPosition:(positionToPut > childCount ? childCount : positionToPut)] setTitle: title];
//    NSAssert([[[self allItems] indexesOfObjectsPassingTest:^(id obj,
//                                                             NSUInteger idx,
//                                                             BOOL *stop)
//             {
//                 return (BOOL)([obj title] == title);
//             }] containsIndex:to],
//             @"broken invariant in MDTreeNodeStore's -moveItemAtRow:toIndex:");
}

@end
