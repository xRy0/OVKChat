//
//  VKNewMessageBackgroundView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 18.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKNewMessageBackgroundView.h"

@implementation VKNewMessageBackgroundView

- (void)dealloc {
    [leftTopImage release];
    [centerTopImage release];
    [rightTopImage release];
    [leftBottomImage release];
    [centerBottomImage release];
    [rightBottomImage release];
    [leftMiddleImage release];
    [centerMiddleImage release];
    [rightMiddleImage release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        leftTopImage = [[NSImage imageNamed:@"FieldLeftTop"] retain];
        centerTopImage = [[NSImage imageNamed:@"FieldTopEnd"] retain];
        rightTopImage = [[NSImage imageNamed:@"FieldRightTop"] retain];
        leftBottomImage = [[NSImage imageNamed:@"FieldLeftBottom"] retain];
        centerBottomImage = [[NSImage imageNamed:@"FieldBottomEnd"] retain];
        rightBottomImage = [[NSImage imageNamed:@"FieldRightBottomTail"] retain];
        leftMiddleImage = [[NSImage imageNamed:@"FieldLeftEnd"] retain];
        centerMiddleImage = [[NSImage imageNamed:@"FieldCenterTile"] retain];
        rightMiddleImage = [[NSImage imageNamed:@"FieldRightEnd"] retain];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect = self.bounds;
    
    rect.origin.y = rect.origin.y + 8;
    rect.origin.x = rect.origin.x + 10;
    rect.size.width = rect.size.width - 20;
    rect.size.height = rect.size.height - 16;
    
    NSDrawNinePartImage(rect, leftTopImage, centerTopImage, rightTopImage, leftMiddleImage, centerMiddleImage, rightMiddleImage, leftBottomImage, centerBottomImage, rightBottomImage, NSCompositeSourceOver, 1.0, self.isFlipped);
}

- (BOOL)isFlipped {
    return YES;
}

@end
