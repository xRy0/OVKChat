//
//  VKMessageTextView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 10.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessageTextView.h"

@implementation VKMessageTextView

@synthesize target;
@synthesize action;
@synthesize actionKey;
@synthesize placeholderString;

- (void)keyUp:(NSEvent *)theEvent {
    NSUInteger modifiers = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;

    if (actionKey == VKMessageTextFieldActionKeyEnter && [theEvent keyCode] == 36 && modifiers == NSShiftKeyMask) {
        self.string = [self.string stringByAppendingString:@"\n"];
        
        if (self.delegate) {
            [self.delegate textViewTextDidChange:self];
        }
        
        return;
    }
    
    if (actionKey == VKMessageTextFieldActionKeyEnter && [theEvent keyCode] == 36) {
        [NSApp sendAction:action to:target from:self];
        return;
    }
    
    if (actionKey == VKMessageTextFieldActionKeyShiftEnter && [theEvent keyCode] == 36 && modifiers == NSShiftKeyMask) {
        [NSApp sendAction:action to:target from:self];
        return;
    }
    
    [super keyUp:theEvent];
    
    if (self.delegate) {
        [self.delegate textViewTextDidChange:self];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    NSUInteger modifiers = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;

    if (actionKey == VKMessageTextFieldActionKeyEnter && [theEvent keyCode] == 36) {
        return;
    }
    
    if (actionKey == VKMessageTextFieldActionKeyEnter && [theEvent keyCode] == 36 && modifiers == NSShiftKeyMask) {
        return;
    }
    
    if (actionKey == VKMessageTextFieldActionKeyEnter && [theEvent keyCode] == 36) {
        return;
    }
    
    if (actionKey == VKMessageTextFieldActionKeyShiftEnter && [theEvent keyCode] == 36 && modifiers == NSShiftKeyMask) {
        return;
    }
    
    [super keyDown:theEvent];
}

/*- (void)drawRect:(NSRect)dirtyRect {
    if ([self.string length] == 0 && placeholderString) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        
        NSFont *font = [NSFont fontWithName:VK_FONT_DIALOGS_MESSAGE size:VK_FONT_SIZE_DIALOGS_MESSAGE];
        
        NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor grayColor], NSForegroundColorAttributeName, font, NSFontAttributeName,
                                                                             paragraphStyle, NSParagraphStyleAttributeName, nil];
        
        [paragraphStyle release];
        
        [placeholderString drawAtPoint:NSMakePoint(6, 0) withAttributes:attsDict];
    } else {
        [super drawRect:dirtyRect];
    }
}

- (BOOL)readSelectionFromPasteboard:(NSPasteboard *)pboard {
	if (self.delegate) {
        [self.delegate textViewTextDidChange:self];
    }
	
	return [super readSelectionFromPasteboard:pboard];
}

- (BOOL)writeSelectionToPasteboard:(NSPasteboard *)pboard types:(NSArray *)types {
	if (self.delegate) {
        [self.delegate textViewTextDidChange:self];
    }
	NSLog(@"WRITE");
	return [super writeSelectionToPasteboard:pboard types:types];
}*/

@end
