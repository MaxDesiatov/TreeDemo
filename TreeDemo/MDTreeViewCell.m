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
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** workaround for iOS 6.0 from http://stackoverflow.com/questions/12600214/contentview-not-indenting-in-ios-6-uitableviewcell-prototype-cell
 */
//- (void)awakeFromNib
//{
//    // -------------------------------------------------------------------
//    // We need to create our own constraint which is effective against the
//    // contentView, so the UI elements indent when the cell is put into
//    // editing mode
//    // -------------------------------------------------------------------
//
//    // Remove the IB added horizontal constraint, as that's effective
//    // against the cell not the contentView
//    [self removeConstraint:self.indicatorLeadingConstraint];
//
//    // Create a dictionary to represent the view being positioned
//    NSDictionary *labelViewDictionary = NSDictionaryOfVariableBindings(_nodeStateIndicator);
//
//    // Create the new constraint
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_nodeStateIndicator]" options:0 metrics:nil views:labelViewDictionary];
//
//    // Add the constraint against the contentView
//    [self.contentView addConstraints:constraints];
//}
//
- (void)layoutSubviews
{
    [super layoutSubviews];

    float indentPoints = self.indentationLevel * self.indentationWidth;

    if (self.editing && needsAdditionalIndentation)
        indentPoints += 32;

    self.contentView.frame = CGRectMake(indentPoints,
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

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGRect b = [self bounds];
//    b.size.width += 30; // allow extra width to slide for editing
//    b.origin.x -= (self.editing) ? 0 : 30; // start 30px left unless editing
//    [self.contentView setFrame:b];
//    // then calculate (NSString sizeWithFont) and addSubView, the textField as appropriate...
//    //
//}


//- (void)layoutSubviews {
//    [super layoutSubviews];
//    CGRect contentRect = self.contentView.bounds;
//
//    if (!self.editing) {
//
//        // get the X pixel spot
//        CGFloat boundsX = contentRect.origin.x;
//        CGRect frame;
//
//        frame = CGRectMake((boundsX + self.indentationLevel + 1) * self.indentationWidth,
//                           0,
//                           SCREEN_WIDTH - (self.level * self.indentationWidth),
//                           CELL_HEIGHT);
//        self.valueLabel.frame = frame;
//
//        CGRect imgFrame;
//        imgFrame = CGRectMake(((boundsX + self.level + 1) * LEVEL_INDENT) - (IMG_HEIGHT_WIDTH + XOFFSET),
//                              YOFFSET,
//                              IMG_HEIGHT_WIDTH,
//                              IMG_HEIGHT_WIDTH);
//        self.arrowImage.frame = imgFrame;
//    }
//}


@end
