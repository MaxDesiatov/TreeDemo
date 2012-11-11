//
//  TreeViewController.m
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeViewController.h"
#import "MDTreeNodeStore.h"
#import "MDTreeNode.h"
#import "MDDetailsViewController.h"
#import "MDTreeViewCell.h"

@implementation MDTreeViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        UINavigationItem *n = [self navigationItem];

        [n setTitle:@"TreeDemo"];

        UIBarButtonItem *bbi =
            [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];

        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }

    return self;
}

/** I don't think that using UITableViewStyleGrouped would look good for a tree
 *  would look good, so using UITableViewStylePlain for both simple and 
 *  designated init
 */
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"MDTreeViewCell" bundle:nil];

    [[self tableView] registerNib:nib forCellReuseIdentifier:@"MDTreeViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[MDTreeNodeStore sharedStore] allNodes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDTreeViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"MDTreeViewCell"];

    if (!cell)
    {
        cell =
            [[MDTreeViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"MDTreeViewCell"];
    }

    MDTreeNode *n =
        [[[MDTreeNodeStore sharedStore] allNodes]
            objectAtIndex:[indexPath row]];
    
    [[cell nodeTitleField] setText:[n description]];
    [cell setIndentationWidth:32];
    [cell setIsExpanded:[n isExpanded]];
    [cell setHasChildren:([[n children] count] > 0)];
    [cell prepareForReuse];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
    indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[MDTreeNodeStore sharedStore] allNodes];
    MDTreeNode *n = [items objectAtIndex:[indexPath row]];

    NSInteger result = -1;

    while (n && n.parent)
    {
        ++result;
        n = n.parent;
    }

    return result;
}

#pragma mark - Table view delegate

- (IBAction)addNewItem:(id)sender
{
    MDTreeNode *newNode = [[MDTreeNodeStore sharedStore] createNode];

    int lastRow =
        [[[MDTreeNodeStore sharedStore] allNodes] indexOfObject:newNode];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];

    [[self tableView] endEditing:YES];
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                            withRowAnimation:UITableViewRowAnimationTop];
    [[self tableView] scrollToRowAtIndexPath:ip
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MDTreeNodeStore *store = [MDTreeNodeStore sharedStore];
        NSArray *items = [store allNodes];
        MDTreeNode *n = [items objectAtIndex:[indexPath row]];
        NSLog(@"deleting row %d", [indexPath row]);
        MDTreeViewCell *cell =
            (MDTreeViewCell *)[tableView cellForRowAtIndexPath:indexPath];

        NSArray *childrenToReload;
        // no need to reload children if they're removed with the parent
        // but if they're not removed with the parent, we need to get those
        // before changes to the store were applied
        if ([cell isExpanded])
        {
            childrenToReload = [n flatten];
            [store removeNode:n];
        } else
            [store removeNodeWithChildren:n];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];

        // no need to reload children if they're removed with the parent
        if (![cell isExpanded])
            return;

        NSMutableArray *indexPathsToReload = [NSMutableArray array];
        // reloading all items to get refreshed indexes
        items = [store allNodes];
        for (MDTreeNode *nodeToReload in childrenToReload)
        {
            NSUInteger index = [items indexOfObjectIdenticalTo:nodeToReload];

            [indexPathsToReload addObject:[NSIndexPath indexPathForRow:index
                                                             inSection:0]];
        }

        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:indexPathsToReload
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)oldPath
           toIndexPath:(NSIndexPath *)newPath
{
    MDTreeNodeStore *store = [MDTreeNodeStore sharedStore];
    NSArray *items = [store allNodes];
    MDTreeNode *n = [items objectAtIndex:[oldPath row]];
    MDTreeViewCell *cell =
        (MDTreeViewCell *)[tableView cellForRowAtIndexPath:oldPath];

    NSArray *childrenToReload;

    // no need to reload children if they're moved with the parent
    // but if they're not moved with the parent, we need to get those
    // before changes to the store were applied
    if ([cell isExpanded])
        childrenToReload = [n flatten];

    NSInteger oldRow = [oldPath row];
    NSInteger newRow = [newPath row];

    if (![cell isExpanded])
        [store moveNodeAtRowWithChildren:oldRow toRow:newRow];
    else
        [store moveNodeAtRow:oldRow toRow:newRow];

    [cell setIndentationLevel:[self tableView:[self tableView]
            indentationLevelForRowAtIndexPath:newPath]];
    [cell setNeedsLayout];

    // no need to reload children if they're moved with the parent
    if (![cell isExpanded])
        return;

    // reloading all items to get refreshed indexes
    items = [store allNodes];
    for (MDTreeNode *nodeToReload in childrenToReload)
    {
        NSUInteger row = [items indexOfObjectIdenticalTo:nodeToReload];
        NSIndexPath *indexPathToUpdate =
            [NSIndexPath indexPathForRow:row inSection:0];

        UITableViewCell *cell =
            [[self tableView] cellForRowAtIndexPath:indexPathToUpdate];
        [cell setIndentationLevel:[self tableView:[self tableView]
                indentationLevelForRowAtIndexPath:indexPathToUpdate]];
        [cell setNeedsLayout];
    }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *nodes = [[MDTreeNodeStore sharedStore] allNodes];
    MDTreeNode *selectedNode = [nodes objectAtIndex:[indexPath row]];
    if ([[selectedNode children] count] < 1)
        return;

    MDTreeViewCell *cell =
        (MDTreeViewCell *)[[self tableView] cellForRowAtIndexPath:indexPath];
    [cell spinNodeStateIndicatorWithDuration:0.25];
    
    BOOL oldIsExpanded = [selectedNode isExpanded];

    if (oldIsExpanded)
    {
        NSArray *flattenedChildren = [selectedNode flatten];
        NSMutableArray *rowsToDelete = [NSMutableArray array];

        for (MDTreeNode *child in flattenedChildren)
        {
            NSUInteger row = [nodes indexOfObjectIdenticalTo:child];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
            [rowsToDelete addObject:ip];
        }

        [selectedNode setIsExpanded:!oldIsExpanded];
        [cell setIsExpanded:!oldIsExpanded];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:rowsToDelete
                         withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
    } else
    {
        [selectedNode setIsExpanded:!oldIsExpanded];
        [cell setIsExpanded:!oldIsExpanded];
        
        NSArray *flattenedChildren = [selectedNode flatten];
        NSMutableArray *rowsToInsert = [NSMutableArray array];
        // refreshing list of all nodes after expand
        nodes = [[MDTreeNodeStore sharedStore] allNodes];

        for (MDTreeNode *child in flattenedChildren)
        {
            NSUInteger row = [nodes indexOfObjectIdenticalTo:child];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
            [rowsToInsert addObject:ip];
        }
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:rowsToInsert
                         withRowAnimation:UITableViewRowAnimationBottom];
        [tableView endUpdates];
    }
    
}

- (void)tableView:(UITableView *)tableView
    accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    MDDetailsViewController *details = [MDDetailsViewController new];

    NSArray *nodes = [[MDTreeNodeStore sharedStore] allNodes];
    MDTreeNode *selectedNode = [nodes objectAtIndex:[indexPath row]];
    [details setNode:selectedNode];

    [[self navigationController] pushViewController:details animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    // forcing reload of data source to avoid any bugs connected with reordering
    // in view and data source not synchronized.  as a side effect, it ends
    // editing without cute animation
    if (!editing)
        [[self tableView] reloadData];
}

@end
