//
//  VKAlbumsItemView.m
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAlbumsItemView.h"

@implementation VKAlbumsItemView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect = NSMakeRect(0, 0, self.bounds.size.width, 200);
    NSImage *background = [NSImage imageNamed:@"Stack"];
    
    [background drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    
    rect = NSMakeRect(26, 26, self.bounds.size.width - 51, 200 - 51);
    
    int cropSize = self.image.size.width;
    
    if (self.image.size.width > self.image.size.height) {
        cropSize = self.image.size.height;
    }
    
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    [path addClip];
    
    [self.image drawInRect:rect fromRect:NSMakeRect(0, 0, cropSize, cropSize) operation:NSCompositeCopy fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    
    [NSGraphicsContext restoreGraphicsState];
    
    VKAlbum *album = (VKAlbum *)self.object;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSColor *color = [NSColor colorWithDeviceRed:139.0/255.0 green:146.0/255.0 blue:165.0/255.0 alpha:0.8];
    
    NSFont *textFont = [NSFont fontWithName:VK_FONT_PHOTO_UPLOAD size:VK_FONT_SIZE_PHOTO_UPLOAD];
    
    NSShadow *textShadow = [[NSShadow alloc] init];
    [textShadow setShadowColor:[NSColor colorWithDeviceWhite:1 alpha:.8]];
    [textShadow setShadowBlurRadius:0];
    [textShadow setShadowOffset:NSMakeSize(0, -1)];
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,
                               textFont, NSFontAttributeName,
                               textShadow, NSShadowAttributeName,
                               paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [album.title drawInRect:NSMakeRect(20, self.bounds.size.height - 20, self.bounds.size.width - 40, 20) withAttributes:attsDict];
    
    [paragraphStyle release];
    [textShadow release];
}

@end
