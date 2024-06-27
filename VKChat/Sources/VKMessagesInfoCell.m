//
//  VKMessagesInfoView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 26.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessagesInfoCell.h"

static NSDictionary *infoCellAttributes = nil;
static NSDictionary *infoCellCenterAttributes = nil;

@implementation VKMessagesInfoCell

@synthesize avatar;
@synthesize icon;
@synthesize text;
@synthesize isUserTyping;

- (void)dealloc {
    [avatar release];
    [icon release];
    [text release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        if (infoCellAttributes == nil) {
            NSShadow *shadow = [[NSShadow alloc] init];
            [shadow setShadowColor:[NSColor colorWithDeviceWhite:1 alpha:.8]];
            [shadow setShadowBlurRadius:0];
            [shadow setShadowOffset:NSMakeSize(0, -1)];

            NSColor *color = [NSColor colorWithDeviceRed:139.0/255.0 green:146.0/255.0 blue:165.0/255.0 alpha:1.0];

            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setAlignment:NSLeftTextAlignment];
            
            infoCellAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                                      [NSFont fontWithName:VK_FONT_INFO_PANEL size:12], NSFontAttributeName, 
                                      shadow, NSShadowAttributeName,
                                      paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
            
            [paragraphStyle release];
            
            paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setAlignment:NSCenterTextAlignment];
            
            infoCellCenterAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                                   [NSFont fontWithName:VK_FONT_INFO_PANEL size:12], NSFontAttributeName, 
                                   shadow, NSShadowAttributeName,
                                   paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
            
            [paragraphStyle release];
            [shadow release];
        }
        
        self.isUserTyping = NO;
        self.text = @"";
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    if (self.isUserTyping) {
        [NSGraphicsContext saveGraphicsState];
        
        NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(4, 6, 20, 20)];
        [path addClip];
        
        [avatar drawInRect:NSMakeRect(4, 6, 20, 20) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
        
        [NSGraphicsContext restoreGraphicsState];
        
        [icon drawInRect:NSMakeRect(24, 8, 42, 23) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
        [text drawInRect:NSMakeRect(76, 14, self.bounds.size.width, 16) withAttributes:infoCellAttributes];
    } else {
        [text drawInRect:NSMakeRect(0, ((int)self.frame.size.height - 16) / 2, (int)self.bounds.size.width, 16) withAttributes:infoCellCenterAttributes];
    }
}

@end
