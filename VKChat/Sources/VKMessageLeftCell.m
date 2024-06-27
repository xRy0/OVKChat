//
//  VKMessageLeftCell.m
//  VKMessages
//
//  Created by Sergey Lenkov on 28.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessageLeftCell.h"

@implementation VKMessageLeftCell

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
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
            
            NSColor *color = [NSColor colorWithDeviceRed:139.0/255.0 green:146.0/255.0 blue:165.0/255.0 alpha:0.8];
            
            timeAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                               messageCellTextFont, NSFontAttributeName, 
                               messageCellTextShadow, NSShadowAttributeName,
                               paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
            [paragraphStyle release];
        }
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    [self calculateWidth];
    
    x = 10;
    
    if (self.showAvatar) {
        [NSGraphicsContext saveGraphicsState];
        
        NSRect frame = NSMakeRect(4, (int)self.frame.size.height - 30, 20, 20);
        
        NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:frame];
        [path addClip];
        
        [self.avatar drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
        
        [NSGraphicsContext restoreGraphicsState];
        
        x = 30;
    }
    
    y = BUBBLE_OFFSET_Y;
    
    x = x + MESSAGE_RIGHT_OFFSET;
    
    NSDrawNinePartImage(NSMakeRect(x - MESSAGE_RIGHT_OFFSET, y, width + MESSAGE_RIGHT_OFFSET + MESSAGE_LEFT_OFFSET, (int)self.frame.size.height - (BUBBLE_OFFSET_Y * 2)),
                        [NSImage imageNamed:@"GrayLeftTop"], [NSImage imageNamed:@"GrayTopEnd"], [NSImage imageNamed:@"GrayRightTop"], 
                        [NSImage imageNamed:@"GrayLeftEnd"], [NSImage imageNamed:@"GrayCenterTile"], [NSImage imageNamed:@"GrayRightEnd"], 
                        [NSImage imageNamed:@"GrayLeftBottomTail"], [NSImage imageNamed:@"GrayBottomEnd"], [NSImage imageNamed:@"GrayRightBottom"], 
                        NSCompositeSourceOver, 1.0, self.isFlipped);
    
    if (self.showTime) {
        int _width = [self.date widthForHeight:20 attributes:timeAttributes];
        [self.date drawInRect:NSMakeRect(width + x + MESSAGE_RIGHT_OFFSET + 8, (int)(self.frame.size.height / 2) - BUBBLE_OFFSET_Y + 2, _width, 20) withAttributes:timeAttributes];
    }
    
    y = y + MESSAGE_TOP_OFFSET;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:messageCellTextFont, NSFontAttributeName,
                              paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [paragraphStyle release];
    
    height = [self.text heightForWidth:width attributes:attsDict];
    textView.frame = NSMakeRect(x, y, width + 11, height);

    if ([self.text length] > 0) {
		NSRect bounds = [self.text boundingRectWithSize:NSMakeSize(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attsDict];
        y = y + bounds.size.height;
    }
	
	if ([self.forwardMessages count] > 0) {
		y = y + QUOTE_OFFSET_Y;
	}
	
    if ([self.forwardMessages count] > 0) {
        int i = 0;
        
        for (VKMessage *message in self.forwardMessages) {
			[self drawMessage:message index:i offset:0];
			i++;
			
			for (VKMessage *_message in message.forwardMessages) {
				[self drawMessage:_message index:i offset:FORWARD_MESSAGE_OFFSET];
				i++;
			}
        }
    }
    
    attacheY = y;
    
    if ([self.attachments count] > 0) {
        if ([self.text length] > 0) {
            y = y + PHOTO_OFFSET_Y;
        }
        
        for (id attach in self.attachments) {
            if ([attach isKindOfClass:[VKSong class]]) {
                NSImage *icon = [NSImage imageNamed:@"PlayButtonInDialogStandby"];
                VKSong *song = (VKSong *)attach;
                
                NSColor *color = [NSColor colorWithDeviceRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
                
                NSFontManager *fontManager = [NSFontManager sharedFontManager];
                NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
                
                NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                                          font, NSFontAttributeName, 
                                          messageCellTextShadow, NSShadowAttributeName, nil];
                
                [song.artist drawInRect:NSMakeRect(x + 36, y - 4, width - 40, 18) withAttributes:attsDict];
                
                font = [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH];
                attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, 
                            font, NSFontAttributeName, 
                            messageCellTextShadow, NSShadowAttributeName, nil];
                
                [song.title drawInRect:NSMakeRect(x + 36, y + 10, width - 40, 18) withAttributes:attsDict];
                
                [icon drawInRect:NSMakeRect(x + 4, y, 27, 27) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
                
                y = y + AUDIO_ATTACH_HEIGHT;
                y = y + AUDIO_OFFSET_Y;
            }
            
            if ([attach isKindOfClass:[VKPhoto class]]) {
                VKPhoto *photo = (VKPhoto *)attach;
                CGSize size = photo.imageBig.size;
                
                float scale = 1.0;
                
                if (size.width > width) {
                    scale = width / size.width;
                }
                
                [photo.imageBig drawInRect:NSMakeRect(x + 4, y, (int)(size.width * scale), (int)(size.height * scale)) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
                
                y = y + size.height * scale;
                y = y + PHOTO_OFFSET_Y;
            }
            
            if ([attach isKindOfClass:[VKVideo class]]) {
                VKVideo *video = (VKVideo *)attach;
                CGSize size = video.imageBig.size;
                
                float scale = 1.0;
                
                if (size.width > width) {
                    scale = width / size.width;
                }
                
                [video.imageBig drawInRect:NSMakeRect(x + 4, y, (int)(size.width * scale) - 4, (int)(size.height * scale)) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
                
                y = y + size.height * scale;
                y = y + PHOTO_OFFSET_Y;
            }
        }
    }
}

- (void)drawMessage:(VKMessage *)message index:(NSInteger)index offset:(NSInteger)offset {
	int _x = x + (int)offset;
	int _width = width - (int)offset;
	
	NSImage *icon = [NSImage imageNamed:@"QuoteIcon"];
	[icon drawInRect:NSMakeRect(_x + ((_width - 12) / 2), y, 16, 12) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
	
	NSString *name = @"";
	
	if (message.profile) {
		name = [NSString stringWithFormat:@"%@ %@", message.profile.firstName, message.profile.lastName];
	}
	
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
	NSColor *color = [NSColor colorWithDeviceRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
	
	NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,
							  font, NSFontAttributeName,
							  messageCellTextShadow, NSShadowAttributeName, nil];
	
	int nameWidth = [name boundingRectWithSize:NSMakeSize(_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attsDict].size.width;
	y = y + QUOTE_ICON_HEIGHT;
	
	[name drawInRect:NSMakeRect(_x + 6, y, nameWidth + 2, 16) withAttributes:attsDict];
	
	attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,
				[NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH], NSFontAttributeName,
				messageCellTextShadow, NSShadowAttributeName, nil];
	
	int dateWidth = [[NSString stringWithFormat:@", %@", [message.date systemTimeRepresentation]] widthForHeight:16 attributes:attsDict];
	
	[[NSString stringWithFormat:@", %@", [message.date systemTimeRepresentation]] drawInRect:NSMakeRect(_x + nameWidth + 6, y, dateWidth, 16) withAttributes:attsDict];
	
	y = y + QUOTE_NAME_HEIGHT + QUOTE_NAME_OFFSET;
	
	height = [message.body boundingRectWithSize:NSMakeSize(_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attsDict].size.height;
	
	NSTextView *_textView = [_textViews objectAtIndex:index];
	_textView.frame = NSMakeRect(_x, y, _width + 11, [message.body heightForWidth:width attributes:attsDict]);
	
	y = y + height;
	
	if ([message.attachments count] > 0) {
		y = y + PHOTO_OFFSET_Y;
		
		for (id attach in message.attachments) {
			if ([attach isKindOfClass:[VKSong class]]) {
				NSImage *icon = [NSImage imageNamed:@"PlayButtonInDialogStandby"];
				VKSong *song = (VKSong *)attach;
				
				NSColor *color = [NSColor colorWithDeviceRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
				
				NSFontManager *fontManager = [NSFontManager sharedFontManager];
				NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
				
				NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,
										  font, NSFontAttributeName,
										  messageCellTextShadow, NSShadowAttributeName, nil];
				
				[song.artist drawInRect:NSMakeRect(_x + 36, y - 4, _width - 40, 18) withAttributes:attsDict];
				
				font = [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH];
				attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,
							font, NSFontAttributeName,
							messageCellTextShadow, NSShadowAttributeName, nil];
				
				[song.title drawInRect:NSMakeRect(_x + 36, y + 10, _width - 40, 18) withAttributes:attsDict];
				
				[icon drawInRect:NSMakeRect(_x + 4, y, 27, 27) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
				
				y = y + AUDIO_ATTACH_HEIGHT;
				y = y + AUDIO_OFFSET_Y;
			}
			
			if ([attach isKindOfClass:[VKPhoto class]]) {
				VKPhoto *photo = (VKPhoto *)attach;
				CGSize size = photo.imageBig.size;
				
				float scale = 1.0;
				
				if (size.width > _width) {
					scale = _width / size.width;
				}
				
				[photo.imageBig drawInRect:NSMakeRect(_x + 4, y, (int)(size.width * scale), (int)(size.height * scale)) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
				
				y = y + size.height * scale;
				y = y + PHOTO_OFFSET_Y;
			}
		}
	}
}

- (void)mouseUp:(NSEvent *)event {
    draggedPhoto = nil;

    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];

    y = attacheY;

    self.selectedAttachmentIndex = 0;
        
    for (id attach in self.attachments) {
        if ([attach isKindOfClass:[VKSong class]]) {
            if (NSPointInRect(point, NSMakeRect(x, y, 32, 32))) {
                [self.target performSelector:self.actionClickedOnAttach withObject:self];
                return;
            }
                
            y = y + 40;
        }

        if ([attach isKindOfClass:[VKPhoto class]]) {
            VKPhoto *photo = (VKPhoto *)attach;
            CGSize size = photo.imageBig.size;
            
            float scale = 1.0;
            
            if (size.width > width) {
                scale = (width - 8) / size.width;
            }
                
            if (NSPointInRect(point, NSMakeRect(x, y, size.width * scale, size.height * scale))) {
                [self.target performSelector:self.actionClickedOnAttach withObject:self];
                return;
            }
            
            y = y + size.height * scale;
            y = y + 10;
        }
            
        self.selectedAttachmentIndex++;
    }
}

- (BOOL)photoAtPoint:(NSPoint)point {
    y = attacheY;
    
    for (id attach in self.attachments) {
        if ([attach isKindOfClass:[VKSong class]]) {
            y = y + 40;
        }
        
        if ([attach isKindOfClass:[VKPhoto class]]) {
            VKPhoto *photo = (VKPhoto *)attach;
            CGSize size = photo.imageBig.size;
            
            float scale = 1.0;
            
            if (size.width > width) {
                scale = (width - 8) / size.width;
            }
            
            if (NSPointInRect(point, NSMakeRect(x, y, size.width * scale, size.height * scale))) {
                draggedPhoto = photo;
                return YES;
            }
            
            y = y + size.height * scale;
            y = y + 10;
        }
    }
    
    return NO;
}

- (NSRect)rectForPhoto:(VKPhoto *)photo {
    y = attacheY;
    
    for (id attach in self.attachments) {
        if ([attach isKindOfClass:[VKSong class]]) {    
            y = y + 40;
        }
        
        if ([attach isKindOfClass:[VKPhoto class]]) {
            VKPhoto *_photo = (VKPhoto *)attach;
            CGSize size = _photo.imageBig.size;
            
            float scale = 1.0;
            
            if (size.width > width) {
                scale = (width - 8) / size.width;
            }
            
            if (_photo == photo) {
                return NSMakeRect(x, y, size.width * scale, size.height * scale);
            }
            
            y = y + size.height * scale;
            y = y + 10;
        }
    }
    
    return NSZeroRect;
}

@end

