//
//  VKPhotoDropView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPhotoDropView.h"

@implementation VKPhotoDropView

@synthesize delegate;

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        isDragOver = NO;
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, NSFilenamesPboardType, nil]];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSImage *image = [NSImage imageNamed:@"PhotoDragAndDrop"];
    
    if (isDragOver) {
        image = [NSImage imageNamed:@"PhotoDragAndDropDropped"];
    }
    
    int x = self.bounds.size.width / 2;
    int y = self.bounds.size.height / 2;
    
    [image drawInRect:NSMakeRect(x - 100, y - 100, 200, 200) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    
    NSColor *color = [NSColor colorWithDeviceRed:79.0/255.0 green:85.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSShadow *textShadow = [[NSShadow alloc] init];
    [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1 alpha:.8]];
    [textShadow setShadowBlurRadius:0];
    [textShadow setShadowOffset:NSMakeSize(0, -1)];
    
    NSFont *textFont = [NSFont fontWithName:VK_FONT_PHOTO_UPLOAD size:VK_FONT_SIZE_PHOTO_UPLOAD];
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                              textFont, NSFontAttributeName, 
                              textShadow, NSShadowAttributeName,
                              paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [paragraphStyle release];
    [textShadow release];
    
    NSString *text = VK_STR_DROP_PICTURES;
    
    if (isDragOver) {
        text = VK_STR_DROP_OVER_PICTURES;
    }
    
    [text drawInRect:NSMakeRect(x - 150, y + 120, 300, 60) withAttributes:attsDict];
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
    NSArray *imageTypes = [NSArray arrayWithObjects:NSPasteboardTypeTIFF, NSFilenamesPboardType, nil];
	
    NSString *desiredType = [pasteboard availableTypeFromArray:imageTypes];
	
	if ([desiredType isEqualToString:NSPasteboardTypeTIFF]) {
        NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
		NSData *pasteboardData = [pasteboard dataForType:desiredType];
        
		if (pasteboardData == nil) {
			return NO;
		}
		
		NSImage *image = [[NSImage alloc] initWithData:pasteboardData];
        [images addObject:image];
        [image release];
        
        [self performSelectorOnMainThread:@selector(didAcceptImages:) withObject:images waitUntilDone:NO];
        
		return YES;
	}
	
    if ([desiredType isEqualToString:NSFilenamesPboardType]) {
		NSArray *files = [pasteboard propertyListForType:@"NSFilenamesPboardType"];
        [NSThread detachNewThreadSelector:@selector(prepareImagesFromFiles:) toTarget:self withObject:files];
        
		return YES;
    }
	
	return NO;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
    [self setNeedsDisplay:YES];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)prepareImagesFromFiles:(NSArray *)files {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *file in files) {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:file];
		
		if (image) {
			[images addObject:image];
		}
        
        [image release];
    }
    
    [self performSelectorOnMainThread:@selector(didAcceptImages:) withObject:images waitUntilDone:NO];
    
    [pool release];
}

- (void)didAcceptImages:(NSArray *)images {
    if (delegate && [delegate respondsToSelector:@selector(dropView: didAcceptedImages:)]) {
        [delegate dropView:self didAcceptedImages:images];
    }
}

@end
