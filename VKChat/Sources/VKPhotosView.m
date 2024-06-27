//
//  VKPhotosView.m
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPhotosView.h"

@implementation VKPhotosView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, NSFilenamesPboardType, nil]];
    }
    
    return self;
}

- (void)addItem:(id)object {
    VKPhotosItemView *thumbView = [[VKPhotosItemView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    thumbView.object = object;
    thumbView.delegate = self;
    thumbView.allowDragging = self.allowDragging;
    
    [self addSubview:thumbView];
    [_thumbs addObject:thumbView];
    
    [self resizeGrid];
}

- (void)addImage:(NSImage *)image {
    [self addItem:image];
    [self setImage:image atIndex:_thumbs.count - 1];
}

#pragma mark -
#pragma mark Drag'n Drop
#pragma mark -

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
		return NSDragOperationCopy;
    }
	
	return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
    
    NSPasteboard *pasteboard = [sender draggingPasteboard];
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
	}
	
    if ([desiredType isEqualToString:NSFilenamesPboardType]) {
		NSArray *files = [pasteboard propertyListForType:@"NSFilenamesPboardType"];

        for (NSString *file in files) {
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:file];
            [images addObject:image];
            [image release];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photosView: didAcceptImages:)]) {
        [self.delegate photosView:self didAcceptImages:images];
    }
    
	return YES;
}

@end
