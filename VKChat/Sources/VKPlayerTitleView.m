//
//  VKPlayerTitleView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 23.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPlayerTitleView.h"

@implementation VKPlayerTitleView

@synthesize artist;
@synthesize title;

- (void)dealloc {
    [artist release];
    [title release];
    [artistFont release];
    [titleFont release];
    [artistAttsDict release];
    [titleAttsDict release];
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        NSFontManager *fontManager = [NSFontManager sharedFontManager];
        artistFont = [[fontManager fontWithFamily:VK_FONT_PLAYER_TITLE traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_PLAYER_TITLE] retain];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        artistAttsDict = [[NSDictionary dictionaryWithObjectsAndKeys:[NSColor whiteColor], NSForegroundColorAttributeName,
                                                                    artistFont, NSFontAttributeName,
                                                                    paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
                                  
        titleFont = [[NSFont fontWithName:VK_FONT_PLAYER_TITLE size:VK_FONT_SIZE_PLAYER_TITLE] retain];
        
        titleAttsDict = [[NSDictionary dictionaryWithObjectsAndKeys:[NSColor whiteColor], NSForegroundColorAttributeName,
                                                                    titleFont, NSFontAttributeName,
                                                                    paragraphStyle, NSParagraphStyleAttributeName, nil] retain];
                    
        [paragraphStyle release];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    if (artist && title) {
        NSSize artistSize = [artist sizeWithAttributes:artistAttsDict];
        NSSize titleSize = [title sizeWithAttributes:titleAttsDict];
        NSSize separatorSize = [@" - " sizeWithAttributes:titleAttsDict];

        int width = artistSize.width + separatorSize.width + titleSize.width;
        
        if (width > self.frame.size.width - 16) {
            width = self.frame.size.width - 16;
        }
        
        int x = (self.frame.size.width - width) / 2;
        int y = 0;
        int _width = artistSize.width;
        
        if (x + artistSize.width > self.frame.size.width - 16) {
            _width = width - x;
        }
        
        [artist drawInRect:NSMakeRect(x, y, _width, self.frame.size.height) withAttributes:artistAttsDict];
        
        x = x + artistSize.width;
        
		if ([title length] > 0) {
			_width = separatorSize.width;
			
			if (x + separatorSize.width > self.frame.size.width - 16) {
				_width = width - x;
			}
			
			[@" - " drawInRect:NSMakeRect(x, y, _width, self.frame.size.height) withAttributes:titleAttsDict];
			
			x = x + separatorSize.width;
		}
        
        _width = titleSize.width;
        
        if (x + titleSize.width > self.frame.size.width - 16) {
            _width = width - x;
        }
        
        [title drawInRect:NSMakeRect(x, y + 1, _width, self.frame.size.height) withAttributes:titleAttsDict];
    }
    
}

- (BOOL)isFlipped {
    return YES;
}

@end
