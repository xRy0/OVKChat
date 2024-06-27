//
//  VKAudioCell.m
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAudioCell.h"

@implementation VKAudioCell

@synthesize artist;
@synthesize title;
@synthesize duration;
@synthesize isPlayed;
@synthesize isCanAdd;
@synthesize isUpload;
@synthesize addTarget;
@synthesize addAction;
@synthesize progressIndicator;

- (void)dealloc {
    [artist release];
    [title release];
    [duration release];
    [activeIcon release];
    [addButton release];
    [progressIndicator release];
    
    [super dealloc];
}

- (id)initWithReusableIdentifier:(NSString *)identifier {
    self = [super initWithReusableIdentifier:identifier];
    
    if (self) {
        self.artist = @"";
        self.title = @"";
        self.duration = @"";
        self.isPlayed = NO;
        self.isCanAdd = NO;
        self.isUpload = NO;
        
        activeIcon = [[NSImage imageNamed:@"SongPlaying"] retain];
        
        addButton = [[NSButton alloc] initWithFrame:NSMakeRect(9, 11, 20, 21)];
        [addButton setBordered:NO];
        [addButton setTitle:@""];
        [addButton setButtonType:NSMomentaryChangeButton];
        [addButton setImage:[NSImage imageNamed:@"AddTrackButtonStandby"]];
        [addButton setAlternateImage:[NSImage imageNamed:@"AddTrackButtonPressed"]];
        [addButton setHidden:YES];
        
        [addButton setAction:@selector(addButtonPressed)];
        [addButton setTarget:self];
        
        [self addSubview:addButton];
        
        progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(8, 24, 200, 14)];
        [progressIndicator setHidden:YES];
        [progressIndicator setStyle:NSProgressIndicatorBarStyle];
        [progressIndicator setBezeled:NO];
        [progressIndicator setIndeterminate:YES];
        [progressIndicator setControlSize:NSSmallControlSize];
        [progressIndicator setMinValue:0];
        [progressIndicator setMaxValue:100];
        
        [self addSubview:progressIndicator];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *color = [NSColor colorWithDeviceRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    if (self.isSelected) {
        color = [NSColor colorWithDeviceRed:235.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1.0];
    }
    
    [color set];
    
    NSRectFill(NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height));
    
    if (isUpload) {
        color = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        
        NSFont *font = [NSFont systemFontOfSize:13];
        NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
        
        [self.title drawInRect:NSMakeRect(8, 12, self.frame.size.width - 80, 18) withAttributes:attsDict];
        
        progressIndicator.frame = NSMakeRect(self.frame.size.width - 210, 15, 200, 12);
        [progressIndicator setHidden:NO];
        [progressIndicator startAnimation:nil];
    } else  {
        int offset = 0;
    
        if (isCanAdd) {
            offset = 30;
        }
    
        color = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
    
        NSFont *font = [NSFont systemFontOfSize:13];
        NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
        [self.title drawInRect:NSMakeRect(8 + offset, 4, self.frame.size.width - 80 - offset, 18) withAttributes:attsDict];
    
        color = [NSColor colorWithDeviceRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
        font = [NSFont systemFontOfSize:11];
        attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
        [self.artist drawInRect:NSMakeRect(8 + offset, 22, self.frame.size.width - 80 - offset, 14) withAttributes:attsDict];
    
        color = [NSColor colorWithDeviceRed:39.0/255.0 green:88.0/255.0 blue:123.0/255.0 alpha:1.0];
        attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
        NSSize size = [duration sizeWithAttributes:attsDict];
    
        [self.duration drawInRect:NSMakeRect(self.frame.size.width - size.width - 8, 14, size.width, 14) withAttributes:attsDict];
    
        [paragraphStyle release];
    
        color = [NSColor colorWithDeviceRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0];
        [color set];
    
        NSRectFill(NSMakeRect(0, 0, self.frame.size.width, 1));
    
        color = [NSColor colorWithDeviceRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        [color set];
    
        NSRectFill(NSMakeRect(0, self.frame.size.height - 1, self.frame.size.width, 1));
    
        if (self.isPlayed) {
            [activeIcon drawInRect:NSMakeRect((int)self.frame.size.width - 40 - (int)size.width, 9, 24, 24) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
        }
    
        if (self.isCanAdd) {
            [addButton setHidden:NO];
        } else {
            [addButton setHidden:YES];
        }
        
        [progressIndicator setHidden:YES];
    }
}

- (BOOL)isFlipped {
    return YES;
}

- (void)addButtonPressed {
    if (addTarget && [addTarget respondsToSelector:addAction]) {
        [addTarget performSelector:addAction withObject:self];
    }
}

@end
