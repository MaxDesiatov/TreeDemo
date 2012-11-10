//
//  MDDetailsViewController.h
//  TreeDemo
//
//  Created by Max Desyatov on 09/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDTreeNode;

@interface MDDetailsViewController : UIViewController
{
    __weak IBOutlet UITextField *titleField;
}

- (IBAction)addChild:(id)sender;
- (IBAction)deleteNode:(id)sender;

@property (nonatomic, strong) MDTreeNode *node;

@end
