//
//  VKDialogCell.m
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDialogCell.h"

static NSShadow *dialogTextShadow = nil;

@implementation VKDialogCell

@synthesize name;
@synthesize text = _text;
@synthesize date;
@synthesize isOnline;
@synthesize isHasUnread;
@synthesize isChat;
@synthesize isHasAttach;
@synthesize avatars;
@synthesize profileAction;
@synthesize profileTarget;
@synthesize deleteAction;
@synthesize deleteTarget;

- (void)dealloc {
    [onlineIcon release];
    [chatIcon release];
    [_text release];
    [name release];
    [date release];
    [avatars release];
    [profileButton release];
    [deleteButton release];
    
    [self removeTrackingArea:trackingArea];
    [trackingArea release];
    
    [super dealloc];
}

- (id)initWithReusableIdentifier:(NSString *)identifier {
    self = [super initWithReusableIdentifier:identifier];
    
    if (self) {
        onlineIcon = [[NSImage imageNamed:@"FriendsListIndicatorOn"] retain];
        chatIcon = [[NSImage imageNamed:@"MultiConversationIcon"] retain];
        
        if (dialogTextShadow == nil) {
            dialogTextShadow = [[NSShadow alloc] init];
            [dialogTextShadow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.4]];
            [dialogTextShadow setShadowBlurRadius:0];
            [dialogTextShadow setShadowOffset:NSMakeSize(0, -1)];
        }
        
        self.text = @"";
        self.name = @"";
        self.date = @"";
        
        profileButton = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 50, 50)];
        [profileButton setBordered:NO];
        [profileButton setTitle:@""];
        [profileButton setButtonType:NSMomentaryChangeButton];
        [profileButton setAction:@selector(profileDidSelected)];
        [profileButton setTarget:self];
        
        [self addSubview:profileButton];

        deleteButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.frame.size.width - 24, 28, 18, 18)];
        [deleteButton setBordered:NO];
        [deleteButton setTitle:@""];
        [deleteButton setButtonType:NSMomentaryChangeButton];
        [deleteButton setImage:[NSImage imageNamed:@"ConversationDeleteButtonStandy"]];
        [deleteButton setAlternateImage:[NSImage imageNamed:@"ConversationDeleteButtonPressed"]];
        [deleteButton setHidden:YES];
        [deleteButton setAction:@selector(dialogDidDeleted)];
        [deleteButton setTarget:self];
        
        [self addSubview:deleteButton];
    }
    
    return self;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    
    [self removeTrackingArea:trackingArea];
    [trackingArea release];
    
    NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self.isSelected) {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:200.0/255.0 green:207.0/255.0 blue:221.0/255.0 alpha:1.0] 
                                                             endingColor:[NSColor colorWithDeviceRed:179.0/255.0 green:188.0/255.0 blue:203.0/255.0 alpha:1.0]];
        [gradient drawInRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) angle:90];
        [gradient release];
    } else {
        if (isHasUnread) {
            [[NSColor colorWithDeviceRed:235.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1.0] set];
        } else {
            [[NSColor colorWithDeviceRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0] set];
        }
        
        NSRectFill(NSMakeRect(0, 0, self.frame.size.width + 3, self.frame.size.height + 2));
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *font = [fontManager fontWithFamily:VK_FONT_DIALOGS_TITLE traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_DIALOGS_TITLE];
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                                                        paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [paragraphStyle release];
    
    NSSize nameSize = [name sizeWithAttributes:attsDict];
    
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSRightTextAlignment];
    
    attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                                          paragraphStyle, NSParagraphStyleAttributeName, nil];
                
    [paragraphStyle release];
    
    NSSize dateSize = [self.date sizeWithAttributes:attsDict];
    
    int x = 72;
    
    if (isChat) {
        x = 42;
    }
    
    int nameX = x;
    int width = nameSize.width;
    
    if (x + width > (int)self.frame.size.width - dateSize.width - 20) {
        width = (int)self.frame.size.width - dateSize.width - 20 - x;
    }
    
    NSColor *color = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    font = [fontManager fontWithFamily:VK_FONT_DIALOGS_TITLE traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_DIALOGS_TITLE];
    
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName,
                                                          dialogTextShadow, NSShadowAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [paragraphStyle release];
    
    [self.name drawInRect:NSMakeRect(x, 8, width, 18) withAttributes:attsDict];
    
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    
    color = [NSColor colorWithDeviceRed:79.0/255.0 green:85.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    if (self.isHasAttach) {
        color = [NSColor colorWithDeviceRed:48.0/255.0 green:83.0/255.0 blue:123.0/255.0 alpha:1.0];
    }
    
    font = [NSFont fontWithName:VK_FONT_DIALOGS_MESSAGE size:VK_FONT_SIZE_DIALOGS_MESSAGE];
    
    attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, 
                                                          dialogTextShadow, NSShadowAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    if (!isChat) {
        [self.text drawInRect:NSMakeRect(72, 26, (int)self.frame.size.width - 100, 30) withAttributes:attsDict];
    }
    
    [paragraphStyle release];
    
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSRightTextAlignment];
    
    color = [NSColor colorWithDeviceRed:58.0/255.0 green:104.0/255.0 blue:141.0/255.0 alpha:1.0];
    attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, 
                                                          dialogTextShadow, NSShadowAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [self.date drawInRect:NSMakeRect((int)self.frame.size.width -  dateSize.width - 10, 10, dateSize.width, 14) withAttributes:attsDict];
    
    [paragraphStyle release];
    
//    NSMutableArray *_rects = [[NSMutableArray alloc] init];
    
    x = 10;
    int y = 10;
        
//    switch ([avatars count]) {
//        case 1:
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x, y, 48, 48)]];
//            break;
//                
//        case 2:
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x, y, 22, 48)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x + 26, y, 24, 48)]];
//            break;
//                
//        case 3:
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x, y, 22, 48)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x + 26, y, 22, 22)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x + 26, y + 26, 22, 22)]];
//            break;
//                
//        case 4:
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x, y, 22, 22)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x, y + 26, 22, 22)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x + 26, y, 22, 22)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x + 26, y + 26, 22, 22)]];
//            break;
//                
//        default:
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x, y, 22, 22)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x, y + 26, 22, 22)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x + 26, y, 22, 22)]];
//            [_rects addObject:[NSValue valueWithRect:NSMakeRect(x + 26, y + 26, 22, 22)]];
//            break;
//    }
    
    if (isChat) {
        NSInteger count = [avatars count];
        
        if ([avatars count] > 4) {
            count = 4;
        }
        
        int _x = x;
        
        for (int i = 0; i < count; i++) {
            NSImage *image = [avatars objectAtIndex:i];
            
            [NSGraphicsContext saveGraphicsState];
            
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(_x, 32, 28, 28) xRadius:5 yRadius:5];
            [path addClip];
            
            [image drawInRect:NSMakeRect(_x, 32, 28, 28) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0 respectFlipped:self.isFlipped hints:nil];
            
            [NSGraphicsContext restoreGraphicsState];
            
            _x = _x + 34;
        }
    } else {
        NSImage *image = [avatars objectAtIndex:0];
        
        [NSGraphicsContext saveGraphicsState];
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x, y, 48, 48) xRadius:5 yRadius:5];
        [path addClip];
        
        [image drawInRect:NSMakeRect(x, y, 48, 48) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0 respectFlipped:self.isFlipped hints:nil];
        
        [NSGraphicsContext restoreGraphicsState];
    }
//        NSRect rect;
//
//        if (i < [_rects count]) {
//            rect = [[_rects objectAtIndex:i] rectValue];
//        } else {
//            rect = [[_rects objectAtIndex:0] rectValue];
//        }
//        
//        if (rect.size.width != rect.size.height) {
//            [NSGraphicsContext saveGraphicsState];
//            
//            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
//            [path addClip];
//            
//            [image drawInRect:NSMakeRect((int)rect.origin.x - 12, (int)rect.origin.y, 48, 48) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0 respectFlipped:self.isFlipped hints:nil];
//            
//            [NSGraphicsContext restoreGraphicsState];
//        } else {
//            [NSGraphicsContext saveGraphicsState];
//            
//            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
//            [path addClip];
//            
//            [image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0 respectFlipped:self.isFlipped hints:nil];
//            
//            [NSGraphicsContext restoreGraphicsState];
//        }
//    }
    
//    [_rects release];

    if (self.isSelected) {
        color = [NSColor colorWithDeviceRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
        [color set];
    
        NSRectFill(NSMakeRect(0, 0, self.frame.size.width, 1));
    
        color = [NSColor colorWithDeviceRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
        [color set];
    
        NSRectFill(NSMakeRect(0, self.frame.size.height - 1, self.frame.size.width, 1));
    } else {
        color = [NSColor colorWithDeviceRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0];
        [color set];
        
        NSRectFill(NSMakeRect(0, 0, self.frame.size.width, 1));
        
        color = [NSColor colorWithDeviceRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
        [color set];
        
        NSRectFill(NSMakeRect(0, self.frame.size.height - 1, self.frame.size.width, 1));
    }
    
    if (isOnline) {
        x = nameX + width + 4;
        [onlineIcon drawInRect:NSMakeRect(x, 14, 8, 9) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    }
    
    if (isChat) {
        [chatIcon drawInRect:NSMakeRect(x, 8, 16, 16) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    }
    
    if (_isMouseOver) {
        [deleteButton setFrame:NSMakeRect(self.frame.size.width - 24, 28, 18, 18)];
        [deleteButton setHidden:NO];
    } else {
        [deleteButton setHidden:YES];
    }
}

- (BOOL)isFlipped {
    return YES;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _isMouseOver = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _isMouseOver = NO;
    [self setNeedsDisplay:YES];
}

- (void)profileDidSelected {
    if (profileTarget && [profileTarget respondsToSelector:profileAction]) {
        [profileTarget performSelector:profileAction withObject:self];
    }
}

- (void)dialogDidDeleted {
    if (deleteTarget && [deleteTarget respondsToSelector:deleteAction]) {
        [deleteTarget performSelector:deleteAction withObject:self];
    }
}

@end
