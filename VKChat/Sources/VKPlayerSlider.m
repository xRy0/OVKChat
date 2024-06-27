//
//  VKPlayerSlider.m
//  VKMessages
//
//  Created by Sergey Lenkov on 29.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPlayerSlider.h"

@implementation VKPlayerSlider

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        knobImage = [NSImage imageNamed:@"TimelineIndicator"];
        leftBaseImage = [NSImage imageNamed:@"LeftTimelineFieldPart"];
        centerBaseImage = [NSImage imageNamed:@"MiddleTimelineFieldPart"];
        rightBaseImage = [NSImage imageNamed:@"RightTimelineFieldPart"];
        leftFillImage = [NSImage imageNamed:@"LeftEndTimeline"];
        centerFillImage = [NSImage imageNamed:@"CenterTimeline"];
        rightFillImage = [NSImage imageNamed:@"RightEndTimeline"];
        
        offset = knobImage.size.width / 2;
        [self calculateTick];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    int knobX = (currentValue.floatValue * tick) + offset;
    
    NSDrawThreePartImage(NSMakeRect(0, 6, self.frame.size.width, 6), leftBaseImage, centerBaseImage, rightBaseImage, NO, NSCompositeSourceOver, 1.0, self.isFlipped);
    NSDrawThreePartImage(NSMakeRect(2, 8, knobX, 2), leftFillImage, centerFillImage, rightFillImage, NO, NSCompositeSourceOver, 1.0, self.isFlipped);
    
    [knobImage drawInRect:NSMakeRect(knobX - (int)knobImage.size.width / 2, 0, 15, 22) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
}

@end
