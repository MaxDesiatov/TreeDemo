//
//  MDDetailsViewController.m
//  TreeDemo
//
//  Created by Max Desyatov on 09/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDDetailsViewController.h"
#import "MDTreeNode.h"
#import "MDTreeNodeStore.h"

@implementation MDDetailsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Details"];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (IBAction)addChild:(id)sender
{
    [[MDTreeNodeStore sharedStore] createChildIn:_node];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)deleteNode:(id)sender
{
    [[MDTreeNodeStore sharedStore] removeItem:_node];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [titleField setText:[_node title]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[self view] endEditing:YES];

    [_node setTitle:[titleField text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([[titleField text] length] < 1)
        [titleField setText:@"Untitled"];

    return YES;
}

@end
