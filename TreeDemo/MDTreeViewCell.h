//
//  MDTreeViewCell.h
//  TreeDemo
//
//  Created by Max Desyatov on 10/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MDTreeViewCell : UITableViewCell
{
    CAShapeLayer *triangleLayer;
    UIBezierPath *path;
    BOOL needsAdditionalIndentation;
}

@property (weak, nonatomic) IBOutlet UITextField *nodeTitleField;
@property (assign) BOOL isExpanded;
@property (assign) BOOL hasChildren;

- (void)spinNodeStateIndicatorWithDuration:(float)duration;

@end
