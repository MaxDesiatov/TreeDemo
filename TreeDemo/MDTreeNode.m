//
//  MDTreeNode.m
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeNode.h"

@implementation MDTreeNode

- (id)init
{
    self = [super init];
    if (self)
    {
        _title = [NSMutableString stringWithString:@"New Item"];
        _isExpanded = YES;
        _children = [NSMutableArray array];
    }

    return self;
}

- (NSString *)description
{
    return _title;
}

@end
