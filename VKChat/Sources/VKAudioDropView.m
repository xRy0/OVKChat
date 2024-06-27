//
//  VKAudioDropView.m
//  VKChat
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAudioDropView.h"

@implementation VKAudioDropView

@synthesize delegate;

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        isDragOver = NO;
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
        isDragOver = YES;
        [self setNeedsDisplay:YES];
        
		return NSDragOperationGeneric;
    }
	
	return NSDragOperationNone;
}

- (void)draggingExited:(id < NSDraggingInfo >)sender {
    isDragOver = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    isDragOver = NO;
    
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    NSArray *imageTypes = [NSArray arrayWithObjects:NSFilenamesPboardType, nil];
	
    NSString *desiredType = [pasteboard availableTypeFromArray:imageTypes];
	
    if ([desiredType isEqualToString:NSFilenamesPboardType]) {
		NSArray *files = [pasteboard propertyListForType:@"NSFilenamesPboardType"];
        //[NSThread detachNewThreadSelector:@selector(prepareImagesFromFiles:) toTarget:self withObject:files];
        //NSLog(@"%@", files);
        NSMutableArray *temp = [NSMutableArray array];
        
        for (NSString *file in files) {
            if ([[[file pathExtension] lowercaseString] isEqualToString:@"mp3"]) {
                [temp addObject:file];
            }
        }
        
        if (delegate && [delegate respondsToSelector:@selector(dropView: didAcceptFiles:)]) {
            [delegate dropView:self didAcceptFiles:temp];
        }
        
		return YES;
    }
	
	return NO;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
    [self setNeedsDisplay:YES];
}

@end
