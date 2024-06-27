//
//  VKTrackingTableView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 23.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKTrackingTableView.h"

@implementation VKTrackingTableView

- (void)dealloc {
    [self removeTrackingArea:trackingArea];
    [super dealloc];
}

- (void)awakeFromNib {
    [[self window] setAcceptsMouseMovedEvents:YES];
    
    NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
    
    trackingArea = [[[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil] autorelease];
    [self addTrackingArea:trackingArea];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint location = [theEvent locationInWindow];
    NSPoint mousePoint = [self convertPoint:location fromView:nil];
        
    NSInteger rowIndex = [self rowAtPoint:mousePoint];
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView: mouseOverRow:)]) {
        [self.delegate tableView:self mouseOverRow:rowIndex];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
     NSInteger rowIndex = -1;
     
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView: mouseOverRow:)]) {
        [self.delegate tableView:self mouseOverRow:rowIndex];
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
