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
@end
