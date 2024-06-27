//
//  VKMessageGroupCell.m
//  VKMessages
//
//  Created by Sergey Lenkov on 04.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessageGroupCell.h"

static NSDictionary *groupCellAttributes = nil;

@implementation VKMessageGroupCell

@synthesize text;

- (void)dealloc {
    [text release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        if (groupCellAttributes == nil) {
            NSShadow *shadow = [[NSShadow alloc] init];
            [shadow setShadowColor:[NSColor colorWithDeviceWhite:1 alpha:.8]];
            [shadow setShadowBlurRadius:0];
            [shadow setShadowOffset:NSMakeSize(0, -1)];
            
            NSFontManager *fontManager = [NSFontManager sharedFontManager];
            NSFont *font = [fontManager fontWithFamily:VK_FONT_DATE traits:NSBoldFontMask weight:0 size:12];
            
            NSColor *color = [NSColor colorWithDeviceRed:139.0/255.0 green:146.0/255.0 blue:165.0/255.0 alpha:1.0];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setAlignment:NSCenterTextAlignment];
            
            groupCellAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                                      font, NSFontAttributeName, shadow, NSShadowAttributeName,
                                      paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
            
            [paragraphStyle release];
            [shadow release];
        }
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    [text drawInRect:NSMakeRect(0, ((int)self.frame.size.height - 16) / 2, (int)self.bounds.size.width, 16) withAttributes:groupCellAttributes];
}

@end
