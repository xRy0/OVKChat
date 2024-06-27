//
//  VKDropStatusBarView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 08.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDropStatusBarView.h"

@implementation VKDropStatusBarView

@synthesize target;
@synthesize action;
@synthesize isClicked;
@synthesize isUnread;
@synthesize delegate;

- (void)dealloc {
    [icon release];
    [iconSelected release];
    [iconUnread release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        isClicked = NO;
        icon = [NSImage imageNamed:@"StatusStandby"];
        iconSelected = [NSImage imageNamed:@"StatusSelected"];
        iconUnread = [NSImage imageNamed:@"StatusOn"];
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, NSFilenamesPboardType, nil]];
    }
    
    return self;
}

- (void)setHighlightState:(BOOL)state {
    if (isClicked != state) {
        isClicked = state;
        [self setNeedsDisplay:YES];
    }
}

- (void)setIsUnread:(BOOL)unread {
    isUnread = unread;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (isClicked) {
        [[NSColor selectedMenuItemColor] set];
        NSRectFill(dirtyRect);
        
        [iconSelected drawInRect:NSMakeRect(0, 0, 29, 23) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    } else {
        if (isUnread) {
            [iconUnread drawInRect:NSMakeRect(0, 0, 29, 23) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
        } else {
            [icon drawInRect:NSMakeRect(0, 0, 29, 23) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
        }
    }
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];

    NSArray *imageTypes = [NSArray arrayWithObjects:NSPasteboardTypeTIFF, NSFilenamesPboardType, nil];
	
    NSString *desiredType = [pasteboard availableTypeFromArray:imageTypes];
	
	if ([desiredType isEqualToString:NSPasteboardTypeTIFF]) { 
		NSData *pasteboardData = [pasteboard dataForType:desiredType];
        
		if (pasteboardData == nil) {
			return NO;
		}
		
		NSImage *image = [[NSImage alloc] initWithData:pasteboardData];
        [images addObject:image];
        [image release];
        
        if (delegate && [delegate respondsToSelector:@selector(dropStatusBarView: didAcceptedImages:)]) {
            [delegate dropStatusBarView:self didAcceptedImages:images];
        }
        
		return YES;
	}
	
    if ([desiredType isEqualToString:NSFilenamesPboardType]) {
		NSArray *files = [pasteboard propertyListForType:@"NSFilenamesPboardType"];
        
        for (NSString *file in files) {
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:file];
            [images addObject:image];
            [image release];
        }

        if (delegate && [delegate respondsToSelector:@selector(dropStatusBarView: didAcceptedImages:)]) {
            [delegate dropStatusBarView:self didAcceptedImages:images];
        }
        
		return YES;
    }
	
	return NO;
}

- (void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    [self setHighlightState:!isClicked];
    
    [self.target performSelectorOnMainThread:self.action withObject:nil waitUntilDone:NO];
}

- (void)rightMouseDown:(NSEvent *)theEvent{
    [super rightMouseDown:theEvent];
    [self setHighlightState:!isClicked];
    
    [self.target performSelectorOnMainThread:self.action withObject:nil waitUntilDone:NO];
}

@end
