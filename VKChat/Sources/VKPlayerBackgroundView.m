//
//  VKPlayerBackgroundView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 19.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPlayerBackgroundView.h"

@implementation VKPlayerBackgroundView

- (void)dealloc {
    [background release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        background = [[NSImage imageNamed:@"BlackBarPart"] retain];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    int x = 0;
    
    while (x < self.frame.size.width) {
        [background drawInRect:NSMakeRect(x, 0, background.size.width, self.frame.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        x = x + background.size.width;
    }
    
}

@end
