//
//  DRThumbView.m
//  Dribbler
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKCollectionItemView.h"

@implementation VKCollectionItemView

@synthesize image;
@synthesize object;
@synthesize delegate;
@synthesize allowDragging;

- (void)dealloc {
    [image release];
    [object release];
    [self removeTrackingArea:trackingArea];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        //[self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
    }
    
    return self;
}

- (void)setAllowDragging:(BOOL)allow {
    allowDragging = allow;
    
    if (allow) {
        [self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
    } else {
        [self unregisterDraggedTypes];
    }
}

- (BOOL)allowDragging {
    return allowDragging;
}

- (void)setObject:(id)aObject {
    object = aObject;
}

- (id)object {
    return object;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    
    [self removeTrackingArea:trackingArea];
    
    NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseDragged:(NSEvent *)event {
    if (allowDragging) {
        [self dragPromisedFilesOfTypes:[NSArray arrayWithObject:NSPasteboardTypeTIFF] fromRect:self.frame source:self slideBack:YES event:event];
    }
}

- (void)mouseDown:(NSEvent *)event {
    //
}

- (void)mouseUp:(NSEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(collectionItemViewDidSelect:)]) {
        [delegate collectionItemViewDidSelect:self];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    //
}

- (void)mouseExited:(NSEvent *)event {
    //
}

- (void)dragImage:(NSImage *)anImage at:(NSPoint)viewLocation offset:(NSSize)initialOffset event:(NSEvent *)event pasteboard:(NSPasteboard *)pboard source:(id)sourceObj slideBack:(BOOL)slideFlag {
    NSImage *dragImage = [[NSImage alloc] initWithSize:self.image.size];

    [dragImage lockFocus];
    [self.image dissolveToPoint:NSZeroPoint fraction:0.5];
    [dragImage unlockFocus];

    [dragImage setScalesWhenResized:YES];
    [dragImage setSize:self.frame.size];

    [super dragImage:dragImage at:NSMakePoint(0, self.frame.size.height) offset:NSZeroSize event:event pasteboard:pboard source:sourceObj slideBack:slideFlag];
}

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination {
    NSString *name = [object name];
    
    NSArray *representations = [self.image representations];
    
    NSData *bitmapData = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSPNGFileType properties:nil];
    [bitmapData writeToFile:[[dropDestination path] stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"png"]] atomically:YES];
        
    return [NSArray arrayWithObjects:[name stringByAppendingPathExtension:@"png"], nil];
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationCopy;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    //
}

- (BOOL)isFlipped {
    return YES;
}

@end
