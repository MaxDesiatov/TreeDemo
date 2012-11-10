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
    return [[[MDTreeNodeStore sharedStore] allItems] count];
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
        [[[MDTreeNodeStore sharedStore] allItems]
            objectAtIndex:[indexPath row]];
    
    [[cell nodeTitleField] setText:[n description]];
    cell.indentationWidth = 32;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
    indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDTreeNode *n =
        [[[MDTreeNodeStore sharedStore] allItems]
            objectAtIndex:[indexPath row]];

    NSInteger result = -1;

    while (n && n.parent)
    {
        ++result;
        n = n.parent;
    }

    NSLog(@"returning indentation %d for row %d", result, [indexPath row]);

    return result;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (IBAction)addNewItem:(id)sender
{
    MDTreeNode *newNode = [[MDTreeNodeStore sharedStore] createItem];

    int lastRow =
        [[[MDTreeNodeStore sharedStore] allItems] indexOfObject:newNode];
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
        NSArray *items = [store allItems];
        MDTreeNode *n = [items objectAtIndex:[indexPath row]];
        NSLog(@"deleting row %d", [indexPath row]);

        NSArray *childrenToReload = [n flatten];
        [store removeItem:n];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];

        NSMutableArray *indexPathsToReload = [NSMutableArray array];
        // reloading all items to get refreshed indexes
        items = [store allItems];
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

//- (void)tableView:(UITableView *)tableView
//    targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)oldPath
//                         toProposedIndexPath:(NSIndexPath *)newPath
//{
////    [[MDTreeNodeStore sharedStore] moveItemAtIndex:[oldPath row]
////                                           toIndex:[newPath row]];
//
//    NSMutableArray *indexPathsToReload =
//        [NSMutableArray arrayWithObject:oldPath];
//    [tableView beginUpdates];
//    [tableView reloadRowsAtIndexPaths:indexPathsToReload
//                     withRowAnimation:UITableViewRowAnimationFade];
//    [tableView endUpdates];
//
//}

- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)oldPath
           toIndexPath:(NSIndexPath *)newPath
{
    MDTreeNodeStore *store = [MDTreeNodeStore sharedStore];
    NSArray *items = [store allItems];
    MDTreeNode *n = [items objectAtIndex:[oldPath row]];
    NSArray *childrenToReload = [n flatten];

    [[MDTreeNodeStore sharedStore] moveItemAtIndex:[oldPath row]
                                           toIndex:[newPath row]];
    UITableViewCell *cell =
        [[self tableView] cellForRowAtIndexPath:oldPath];
    [cell setIndentationLevel:[self tableView:[self tableView]
            indentationLevelForRowAtIndexPath:newPath]];
    [cell layoutIfNeeded];

    // reloading all items to get refreshed indexes
    items = [store allItems];
    for (MDTreeNode *nodeToReload in childrenToReload)
    {
        NSUInteger row = [items indexOfObjectIdenticalTo:nodeToReload];
        NSIndexPath *indexPathToUpdate =
            [NSIndexPath indexPathForRow:row inSection:0];

        UITableViewCell *cell =
            [[self tableView] cellForRowAtIndexPath:indexPathToUpdate];
        [cell setIndentationLevel:[self tableView:[self tableView]
                indentationLevelForRowAtIndexPath:indexPathToUpdate]];
        [cell layoutIfNeeded];
    }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView
    accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    MDDetailsViewController *details = [MDDetailsViewController new];

    NSArray *nodes = [[MDTreeNodeStore sharedStore] allItems];
    MDTreeNode *selectedNode = [nodes objectAtIndex:[indexPath row]];
    [details setNode:selectedNode];

    [[self navigationController] pushViewController:details animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    MDTreeViewCell *cell =
//        (MDTreeViewCell *)[[self tableView]
//                                cellForRowAtIndexPath:[NSIndexPath
//                                                        indexPathForRow:0
//                                                              inSection:0]];
//    UITextField *field = [cell nodeTitleField];
//    [field setEnabled:YES];
//    [field becomeFirstResponder];
//}

@end
