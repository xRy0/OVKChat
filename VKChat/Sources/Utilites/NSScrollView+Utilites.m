//
//  NSScrollView+Utilites.m
//  VKMessages
//
//  Created by Sergey Lenkov on 24.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "NSScrollView+Utilites.h"

@implementation NSScrollView (Utilites)

- (void)scrollToTop {
    NSPoint newScrollOrigin;
    
    if ([self.documentView isFlipped]) {
        newScrollOrigin=NSMakePoint(0.0,0.0);
    } else {
        newScrollOrigin = NSMakePoint(0.0, NSMaxY([self.documentView frame]) - NSHeight([self.contentView bounds]));
    }
    
    [self.documentView scrollPoint:newScrollOrigin];
    
}

- (void)scrollToBottom {
    NSPoint newScrollOrigin;
    
    if ([self.documentView isFlipped]) {
        newScrollOrigin = NSMakePoint(0.0, NSMaxY([self.documentView frame]) - NSHeight([self.contentView bounds]));
    } else {
        newScrollOrigin = NSMakePoint(0.0, 0.0);
    }
    
    [self.documentView scrollPoint:newScrollOrigin];
}

@end
