//
//  VKMessageCell.m
//  VKMessages
//
//  Created by Sergey Lenkov on 14.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessageCell.h"

@implementation VKMessageCell

@synthesize text = _text;
@synthesize attachments;
@synthesize forwardMessages;
@synthesize selectedAttachmentIndex;
@synthesize date;
@synthesize avatar;
@synthesize showTime;
@synthesize showAvatar;
@synthesize target;
@synthesize actionClickedOnAttach;
@synthesize actionClickOnErrorIcon;
@synthesize isError;
@synthesize row;
@synthesize contentWidth;

- (void)dealloc {
    [textView release];
    [_text release];
    [attachments release];
    [date release];
    [avatar release];
    [_textViews release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];

    if (self) {
        [self _init];
        
        textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];

        [textView setEditable:NO];
        [textView setSelectable:YES];
        [textView setBackgroundColor:[NSColor clearColor]];

        [self addSubview:textView];
        
        _textViews = [[NSMutableArray alloc] init];
        
        [self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
    }
    
    return self;
}

- (void)_init {
    if (messageCellTextFont == nil) {
        messageCellTextFont = [[NSFont fontWithName:VK_FONT_MESSAGE size:VK_FONT_SIZE_MESSAGE] retain];
    }
    
    if (messageCellTextShadow == nil) {
        messageCellTextShadow = [[NSShadow alloc] init];
        [messageCellTextShadow setShadowColor:[NSColor colorWithDeviceWhite:1 alpha:.8]];
        [messageCellTextShadow setShadowBlurRadius:0];
        [messageCellTextShadow setShadowOffset:NSMakeSize(0, -1)];
    }
    
    if (textAttributes == nil) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        
        textAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:[NSColor blackColor], NSForegroundColorAttributeName,
                                  messageCellTextFont, NSFontAttributeName,
                                  messageCellTextShadow, NSShadowAttributeName,
                                  paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
            
        [paragraphStyle release];
    }
    
    if (timeAttributes == nil) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        
        NSColor *color = [NSColor colorWithDeviceRed:139.0/255.0 green:146.0/255.0 blue:165.0/255.0 alpha:0.6];
        
        timeAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                           messageCellTextFont, NSFontAttributeName, 
                           messageCellTextShadow, NSShadowAttributeName,
                           paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
        [paragraphStyle release];
    }
}

- (BOOL)isFlipped {
    return YES;
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if (draggedPhoto == nil && [self photoAtPoint:point]) {
        [self dragPromisedFilesOfTypes:[NSArray arrayWithObject:NSPasteboardTypeTIFF] fromRect:self.frame source:self slideBack:YES event:event];
    }    
}

- (void)mouseDown:(NSEvent *)event {
    //
}

- (void)dragImage:(NSImage *)anImage at:(NSPoint)viewLocation offset:(NSSize)initialOffset event:(NSEvent *)event pasteboard:(NSPasteboard *)pboard source:(id)sourceObj slideBack:(BOOL)slideFlag {
    if (draggedPhoto) {
        NSRect rect = [self rectForPhoto:draggedPhoto];
        
        NSImage *dragImage = [[NSImage alloc] initWithSize:draggedPhoto.imageBig.size];

        [dragImage lockFocus];
        [draggedPhoto.imageBig dissolveToPoint:NSZeroPoint fraction:0.5];
        [dragImage unlockFocus];
        
        [dragImage setScalesWhenResized:YES];
        [dragImage setSize:rect.size];
        
        NSPoint point = [self rectForPhoto:draggedPhoto].origin;
        point.y = point.y + rect.size.height;
        
        [super dragImage:dragImage at:point offset:NSZeroSize event:event pasteboard:pboard source:sourceObj slideBack:slideFlag];
        [dragImage release];
    }
}

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination {
    if (draggedPhoto) {
        NSArray *representations = [draggedPhoto.imageBig representations];
        
        NSData *bitmapData = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSPNGFileType properties:nil];
        [bitmapData writeToFile:[[dropDestination path] stringByAppendingPathComponent:[draggedPhoto.urlBig lastPathComponent]] atomically:YES];
        
        return [NSArray arrayWithObjects:[draggedPhoto.urlBig lastPathComponent], nil];
    }
    
    return nil;
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationCopy;
}

- (BOOL)photoAtPoint:(NSPoint)point {
    return NO;
}

- (NSRect)rectForPhoto:(VKPhoto *)photo {
    return NSZeroRect;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)setText:(NSString *)newText {
    [_text release];
    _text = [newText copy];
                              
    NSMutableAttributedString *attributedStatusString = [[NSMutableAttributedString alloc] initWithString:_text];
    [attributedStatusString addAttributes:textAttributes range:NSMakeRange(0, [_text length])];
    
    [textView setTextContainerInset:NSZeroSize];
	[[textView textStorage] setAttributedString:attributedStatusString];
    
    [attributedStatusString release];
    [textView detectAndAddLinks];
}

- (void)setForwardMessages:(NSArray *)aForwardMessages {
    [forwardMessages release];
    forwardMessages = [aForwardMessages retain];
    
    [_textViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_textViews removeAllObjects];
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithDeviceRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                        [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH], NSFontAttributeName,
                                                                         messageCellTextShadow, NSShadowAttributeName, nil];
                
    for (VKMessage *message in forwardMessages) {
        NSTextView *_textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
        
        [_textView setEditable:NO];
        [_textView setSelectable:YES];
        [_textView setBackgroundColor:[NSColor clearColor]];
        [_textView setTextContainerInset:NSMakeSize(0, 0)];
        [_textView setFont:[NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH]];
        
        NSMutableAttributedString *attributedStatusString = [[NSMutableAttributedString alloc] initWithString:message.body];
        [attributedStatusString addAttributes:attsDict range:NSMakeRange(0, [message.body length])];
        
        [[_textView textStorage] setAttributedString:attributedStatusString];
        
        [attributedStatusString release];
        [_textView detectAndAddLinks];
        
        [_textViews addObject:_textView];
        [self addSubview:_textView];
        [_textView release];
		
		for (VKMessage *_message in message.forwardMessages) {
			NSTextView *_textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
			
			[_textView setEditable:NO];
			[_textView setSelectable:YES];
			[_textView setBackgroundColor:[NSColor clearColor]];
			[_textView setTextContainerInset:NSMakeSize(0, 0)];
			[_textView setFont:[NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH]];
			
			NSMutableAttributedString *attributedStatusString = [[NSMutableAttributedString alloc] initWithString:_message.body];
			[attributedStatusString addAttributes:attsDict range:NSMakeRange(0, [_message.body length])];
			
			[[_textView textStorage] setAttributedString:attributedStatusString];
			
			[attributedStatusString release];
			[_textView detectAndAddLinks];
			
			[_textViews addObject:_textView];
			[self addSubview:_textView];
			[_textView release];
		}
    }
}

- (int)calculateWidth {
    int maxWidth = self.frame.size.width / 2 + 60;
    
    if (!self.showAvatar) {
        maxWidth = maxWidth + 60;
    }
    
    width = (int)self.contentWidth + 5;
    
    if (width > maxWidth) {
        width = maxWidth;
    }
    
    return width;
}

@end
