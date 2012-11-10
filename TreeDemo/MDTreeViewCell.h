//
//  MDTreeViewCell.h
//  TreeDemo
//
//  Created by Max Desyatov on 10/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDTreeViewCell : UITableViewCell
{
    BOOL needsAdditionalIndentation;
}

@property (weak, nonatomic) IBOutlet UIView *nodeStateIndicator;
@property (weak, nonatomic) IBOutlet UITextField *nodeTitleField;

@end
