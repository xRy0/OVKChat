//
//  VKDialogInfoCell.m
//  VKMessages
//
//  Created by Sergey Lenkov on 04.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDialogInfoCell.h"

@implementation VKDialogInfoCell

@synthesize text;
@synthesize action;
@synthesize target;

- (void)dealloc {
    [text release];
    [textShadow release];
    [super dealloc];
}

- (id)initWithReusableIdentifier:(NSString *)identifier {
    self = [super initWithReusableIdentifier:identifier];
    
    if (self) {
        self.text = @"";
        
        textShadow = [[NSShadow alloc] init];
        [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.4]];
        [textShadow setShadowBlurRadius:0];
        [textShadow setShadowOffset:NSMakeSize(0, -1)];
		
		actionButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
        [actionButton setBordered:NO];
        [actionButton setTitle:@""];
        [actionButton setButtonType:NSMomentaryChangeButton];
        [actionButton setAction:@selector(buttonDidPressed)];
        [actionButton setTarget:self];
        
        [self addSubview:actionButton];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	actionButton.frame = self.bounds;
	
    [[NSColor colorWithDeviceRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0] set];
    NSRectFill(NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height));

    NSColor *color = [NSColor colorWithDeviceRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSFont *font = [NSFont fontWithName:VK_FONT_DIALOGS_MESSAGE size:VK_FONT_SIZE_DIALOGS_MESSAGE];
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName,
                                                                        textShadow, NSShadowAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [paragraphStyle release];
    
    [self.text drawInRect:NSMakeRect(4, 16, self.frame.size.width - 8, self.frame.size.height - 8) withAttributes:attsDict];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)buttonDidPressed {
	if (target && [target respondsToSelector:action]) {
        [target performSelector:action withObject:self];
    }
}

@end
