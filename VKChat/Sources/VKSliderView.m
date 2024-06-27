//
//  VKSliderView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 29.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSliderView.h"

@implementation VKSliderView

@synthesize minValue;
@synthesize maxValue;
@synthesize currentValue;
@synthesize target;
@synthesize action;

- (void)dealloc {
    [minValue release];
    [maxValue release];
    [currentValue release];
    [knobImage release];
    [leftBaseImage release];
    [centerBaseImage release];
    [rightBaseImage release];
    [leftFillImage release];
    [centerFillImage release];
    [rightFillImage release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        self.minValue = [NSNumber numberWithInt:0];
        self.maxValue = [NSNumber numberWithInt:0];
        self.currentValue = [NSNumber numberWithInt:0];
        
        [self updateTrackingArea];
        offset = 0;
        [self calculateTick];
    }
    
    return self;
}

- (void)calculateTick {
    tick = (self.frame.size.width - (offset * 2)) / maxValue.floatValue;
}

- (void)calculateCurrentValue {
    float value = (mousePoint.x - offset) / tick;
    
    if (value < minValue.floatValue) {
        value = minValue.floatValue;
    }
    
    if (value > maxValue.floatValue) {
        value = maxValue.floatValue;
    }
    
    self.currentValue = [NSNumber numberWithFloat:value];

    if (target && [target respondsToSelector:action]) {
        [target performSelector:action withObject:self];
    }
}

- (void)setMinValue:(NSNumber *)value {
    [minValue release];
    minValue = [value retain];
    
    [self calculateTick];
    [self setNeedsDisplay:YES];
}

- (void)setMaxValue:(NSNumber *)value {
    [maxValue release];
    maxValue = [value retain];
    
    [self calculateTick];
    [self setNeedsDisplay:YES];
}

- (void)setCurrentValue:(NSNumber *)value {
    [currentValue release];
    currentValue = [value retain];
    
    if (currentValue.floatValue < minValue.floatValue) {
        currentValue = minValue;
    }
    
    if (currentValue.floatValue > maxValue.floatValue) {
        currentValue = maxValue;
    }
    
    [self calculateTick];
    [self setNeedsDisplay:YES];
}

- (NSNumber *)currentValue {
    return currentValue;
}

- (void)viewDidEndLiveResize {
    [self calculateTick];
}

- (BOOL)isFlipped {
    return YES;
}

#pragma mark -
#pragma mark Mouse Events
#pragma mark -

- (void)mouseDown:(NSEvent *)event {
    isMouseDown = YES;
    [[self window] setAcceptsMouseMovedEvents:YES];
    NSPoint location = [event locationInWindow];
    mousePoint = [self convertPoint:location fromView:nil];
    
    [self calculateCurrentValue];
}

- (void)mouseUp:(NSEvent *)event {
    isMouseDown = NO;
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint location = [event locationInWindow];
    mousePoint = [self convertPoint:location fromView:nil];
    
    [self calculateCurrentValue];
}

- (void)updateTrackingArea {
	[self removeTrackingArea:trackingArea];
	
	NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingActiveInActiveApp | NSTrackingEnabledDuringMouseDrag;
	
	trackingArea = [[[NSTrackingArea alloc] initWithRect:self.bounds options:trackingOptions owner:self userInfo:nil] autorelease];
	[self addTrackingArea:trackingArea];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

@end
