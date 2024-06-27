//
//  VKMenuItemView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMenuCell.h"

#define INNER_OFFSET 10
#define EXT_OFFSET 10

@implementation VKMenuCell

@synthesize name;
@synthesize icon;
@synthesize badge;
@synthesize isSeparator;

- (id)init {
    self = [super init];
    
    if (self) {
        self.name = @"";
        self.badge = @"";
    }
    
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    if (self.isHighlighted) {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:184.0/255.0 green:194.0/255.0 blue:216.0/255.0 alpha:1.0] 
                                                             endingColor:[NSColor colorWithDeviceRed:157.0/255.0 green:170.0/255.0 blue:196.0/255.0 alpha:1.0]];
        [gradient drawInRect:NSMakeRect(cellFrame.origin.x - 1, cellFrame.origin.y - 1, cellFrame.size.width + 3, cellFrame.size.height + 2) angle:90];
        [gradient release];
    } else {
        [[NSColor colorWithDeviceRed:233.0/255.0 green:237.0/255.0 blue:242.0/255.0 alpha:1.0] set];
        NSRectFill(NSMakeRect(cellFrame.origin.x - 1, cellFrame.origin.y - 1, cellFrame.size.width + 3, cellFrame.size.height + 2));
    }
    
    if (self.isSeparator) {
        int y = cellFrame.origin.y + (cellFrame.size.height / 2);
        
        [[NSColor colorWithDeviceRed:213.0/255.0 green:218.0/255.0 blue:223.0/255.0 alpha:1.0] set];
        NSRectFill(NSMakeRect(cellFrame.origin.x, y, cellFrame.size.width, 1));
        
        [[NSColor colorWithDeviceRed:244.0/255.0 green:246.0/255.0 blue:249.0/255.0 alpha:1.0] set];
        NSRectFill(NSMakeRect(cellFrame.origin.x, y + 1, cellFrame.size.width, 1));
        
        return;
    }
    
    NSColor *color = [NSColor colorWithDeviceRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    
    if (self.isHighlighted) {
        color = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    
    NSFont *font = [NSFont fontWithName:VK_FONT_MENU size:VK_FONT_SIZE_MENU];
    
    if (self.isHighlighted) {
        NSFontManager *fontManager = [NSFontManager sharedFontManager];
        font = [fontManager fontWithFamily:VK_FONT_MENU traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MENU];
    }
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    if (self.isHighlighted) {
        NSShadow *shadow = [[NSShadow alloc] init];
        
        [shadow setShadowColor:[NSColor colorWithDeviceRed:124.0/255.0 green:134.0/255.0 blue:154.0/255.0 alpha:1.0]];
        [shadow setShadowOffset:NSMakeSize(0, -1.0)];
        [shadow setShadowBlurRadius:0.8];
        
        attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, 
                                                              shadow, NSShadowAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
        [shadow release];
    } 
    
    NSSize nameSize = [self.name sizeWithAttributes:attsDict];
    
    [self.name drawInRect:NSMakeRect(cellFrame.origin.x + 32, cellFrame.origin.y + 5, nameSize.width, 20) withAttributes:attsDict];
    [self.icon drawInRect:NSMakeRect((int)cellFrame.origin.x + 8, (int)cellFrame.origin.y + 6, 16, 16) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.controlView.isFlipped hints:nil];
    
    [paragraphStyle release];
    
    if (self.isHighlighted) {
        [[NSColor colorWithDeviceRed:140.0/255.0 green:152.0/255.0 blue:177.0/255.0 alpha:1.0] set];
        NSRectFill(NSMakeRect(cellFrame.origin.x, cellFrame.origin.y + cellFrame.size.height, cellFrame.size.width, 1));
    }
    
    if ([self.badge length] > 0) {
        NSSize size = [self.badge sizeWithAttributes:attsDict];
        
        int width = size.width + INNER_OFFSET * 2;
        int y = (cellFrame.size.height - 18) / 2;
        int x = cellFrame.size.width - width - EXT_OFFSET;
        
        if (self.isHighlighted) {
            [[NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] set];
            
            NSShadow *shadow = [[NSShadow alloc] init];
            
            [shadow setShadowColor:[NSColor colorWithDeviceRed:124.0/255.0 green:134.0/255.0 blue:154.0/255.0 alpha:1.0]];
            [shadow setShadowOffset:NSMakeSize(0, -1.0)];
            [shadow setShadowBlurRadius:0.8];
            
            [shadow set];
            
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x, y, width, 18) xRadius:10 yRadius:10];
            [path fill];
            
            [shadow setShadowColor:nil];
            [shadow set];
            
            [shadow release];
            
            color = [NSColor colorWithDeviceRed:157.0/255.0 green:170.0/255.0 blue:196.0/255.0 alpha:1.0];
        } else {
            [[NSColor colorWithDeviceRed:136.0/255.0 green:164.0/255.0 blue:194.0/255.0 alpha:1.0] set];

            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x, y, width, 18) xRadius:10 yRadius:10];
            [path fill];
            
            color = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        }
        
        font = [NSFont boldSystemFontOfSize:12];
        attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
        
        y = (cellFrame.size.height - 16) / 2;
        x = cellFrame.size.width - size.width - INNER_OFFSET * 2;
        
        [self.badge drawInRect:NSMakeRect(x + 1, y, size.width, 16) withAttributes:attsDict];
    }
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView {
	return NSCellHitContentArea;
}

@end
