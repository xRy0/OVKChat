//
//  VKProfileButton.m
//  VKMessages
//
//  Created by Sergey Lenkov on 17.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKProfileButtonCell.h"

@implementation VKProfileButtonCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    if (self.isHighlighted) {
        [super drawWithFrame:cellFrame inView:controlView];
        return;
    }
    
    NSShadow *textShadow = [[NSShadow alloc] init];
    NSColor *color = [NSColor blackColor];

    if (isMouseOver) {
        [[NSColor colorWithDeviceRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] set];
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:8 yRadius:8];
        [path fill];
        
        color = [NSColor whiteColor];
        
        [textShadow setShadowColor:[NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4]];
        [textShadow setShadowBlurRadius:0];
        [textShadow setShadowOffset:NSMakeSize(0, -1)];
    } else {
        [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.8]];
        [textShadow setShadowBlurRadius:0];
        [textShadow setShadowOffset:NSMakeSize(0, -1)];
    }
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                                                                        self.font, NSFontAttributeName,
                                                                        textShadow, NSShadowAttributeName, nil];
    
    NSRect rect = cellFrame;
    rect.origin.x = 7;
    rect.size.width = cellFrame.size.width - 8;
    
    [self.title drawInRect:rect withAttributes:attsDict];
    
    [textShadow release];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    isMouseOver = YES;
    [self.controlView setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    isMouseOver = NO;
    [self.controlView setNeedsDisplay:YES];
}

@end
