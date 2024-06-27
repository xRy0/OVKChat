//
//  VKLoadMoreView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 06.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKLoadMoreView.h"

@implementation VKLoadMoreView

@synthesize target;
@synthesize action;
@synthesize title;

- (void)drawRect:(NSRect)dirtyRect {
    NSImage *image = [NSImage imageNamed:@"PreviousMessagesButtonStandby"];
    
    if (isMouseDown) {
        image = [NSImage imageNamed:@"PreviousMessagesButtonPressed"];
    }
    
    [image drawInRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor colorWithDeviceWhite:1 alpha:.8]];
    [shadow setShadowBlurRadius:0];
    [shadow setShadowOffset:NSMakeSize(0, -1)];
    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE traits:NSBoldFontMask weight:0 size:12];
    
    NSColor *color = [NSColor colorWithDeviceRed:97.0/255.0 green:105.0/255.0 blue:127.0/255.0 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,
                            font, NSFontAttributeName, shadow, NSShadowAttributeName,
                            paragraphStyle, NSParagraphStyleAttributeName, nil];

    [paragraphStyle release];
    [shadow release];
    
    [self.title drawInRect:NSMakeRect(0, 3, self.frame.size.width, self.frame.size.height) withAttributes:dict];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    isMouseDown = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    isMouseDown = YES;
    [self setNeedsDisplay:YES];
    
    if (target) {
        [target performSelector:action];
    }
}

@end
