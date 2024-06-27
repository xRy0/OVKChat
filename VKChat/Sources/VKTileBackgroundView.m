//
//  VKTileBackgroundView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 18.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKTileBackgroundView.h"

@implementation VKTileBackgroundView

@synthesize tile;
@synthesize color;

- (void)dealloc {
    [tile release];
    [color release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (color) {
        [color set];
        NSRectFill(self.bounds);
    }
    
    if (tile) {
        [[NSColor colorWithPatternImage:tile] set];
        NSRectFill(dirtyRect);
    }
}

@end
