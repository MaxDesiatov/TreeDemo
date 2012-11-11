//
//  MDTreeViewCell.m
//  TreeDemo
//
//  Created by Max Desyatov on 10/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeViewCell.h"

@implementation MDTreeViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        needsAdditionalIndentation = NO;
        _isExpanded = YES;
        _hasChildren = NO;
    }
    
    return self;
}

- (void)prepareForReuse
{
    [triangleLayer removeFromSuperlayer];
    path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addLineToPoint:CGPointMake(6.25, 12.5)];
    [path addLineToPoint:CGPointMake(12.5, 0.0)];
    [path closePath];
    triangleLayer = [CAShapeLayer layer];
    [triangleLayer setBounds:CGRectMake(0.0, 0.0, 12.5, 12.5)];
    [triangleLayer setPosition:CGPointMake(32.0, 22.0)];
    [triangleLayer setPath:[path CGPath]];
    
    if (_hasChildren)
    {
        [[[self contentView] layer] addSublayer:triangleLayer];

        // rotating to proper position without animation, duration 0.0
        // doesn't work though
        if (!_isExpanded)
            [self spinNodeStateIndicatorWithDuration:0.0001];
        
    } else
    {
        [triangleLayer setFillColor:[[UIColor whiteColor] CGColor]];
        [triangleLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [[[self contentView] layer] addSublayer:triangleLayer];

        // rotating to proper position without animation, duration 0.0
        // doesn't work though
        [self spinNodeStateIndicatorWithDuration:0.0001];
    }
    
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    float indentPoints = self.indentationLevel * self.indentationWidth;

    if (self.editing && needsAdditionalIndentation)
        indentPoints += 32;

    self.contentView.frame =
        CGRectMake(indentPoints,
                   self.contentView.frame.origin.y,
                   self.contentView.frame.size.width - indentPoints,
                   self.contentView.frame.size.height);
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    needsAdditionalIndentation =
        state & UITableViewCellStateShowingEditControlMask;
}

- (void)spinNodeStateIndicatorWithDuration:(float)duration
{
    CABasicAnimation *spin =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:-M_PI_2]];
    [spin setDuration:duration];
    [spin setSpeed:(_isExpanded ? 1 : -1)];
    [spin setRemovedOnCompletion:NO];
    [spin setFillMode:kCAFillModeForwards];
    [triangleLayer addAnimation:spin forKey:@"spinAnimation"];
}

@end
