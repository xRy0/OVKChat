//
//  VKPhotosItemView.m
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPhotosItemView.h"

@implementation VKPhotosItemView

- (void)drawRect:(NSRect)dirtyRect {
    NSDrawNinePartImage(self.bounds, [NSImage imageNamed:@"LeftTopEnd"], [NSImage imageNamed:@"TopEnd"], [NSImage imageNamed:@"RightTopEnd"],
                        [NSImage imageNamed:@"LeftMiddleEnd"], [NSImage imageNamed:@"CenterMiddle"], [NSImage imageNamed:@"RightMiddleEnd"],
                        [NSImage imageNamed:@"LeftBottomEnd"], [NSImage imageNamed:@"BottomEnd"], [NSImage imageNamed:@"RightBottomEnd"], NSCompositeSourceOver, 1.0, self.isFlipped);
    
    NSRect rect = NSMakeRect(10, 8, self.bounds.size.width - 20, self.bounds.size.height - 20);
    
    int cropSize = self.image.size.width;
    
    if (self.image.size.width > self.image.size.height) {
        cropSize = self.image.size.height;
    }
    
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    [path addClip];
    
    [self.image drawInRect:rect fromRect:NSMakeRect(0, 0, cropSize, cropSize) operation:NSCompositeCopy fraction:1.0 respectFlipped:self.isFlipped hints:nil];
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
