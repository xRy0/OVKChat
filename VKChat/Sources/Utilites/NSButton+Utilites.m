//
//  NSButton+Utilites.m
//  VKMessages
//
//  Created by Sergey Lenkov on 15.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "NSButton+Utilites.h"

@implementation NSButton (Utilites)

- (void)setTextColor:(NSColor *)color {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                            initWithAttributedString:[self attributedTitle]];
    NSInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    [attrTitle addAttribute:NSForegroundColorAttributeName
                      value:color
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    [attrTitle release];
}

@end
