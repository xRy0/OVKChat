//
//  VKVolumeSlider.m
//  VKMessages
//
//  Created by Sergey Lenkov on 29.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKVolumeSlider.h"

@implementation VKVolumeSlider

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        knobImage = [NSImage imageNamed:@"VolumeHandle"];
        leftBaseImage = [NSImage imageNamed:@"LeftVolumeBasePart"];
        centerBaseImage = [NSImage imageNamed:@"MiddleVolumeBasePart"];
        rightBaseImage = [NSImage imageNamed:@"RightVolumeBasePart"];
        leftFillImage = [NSImage imageNamed:@"LeftVolumeFillerPart"];
        centerFillImage = [NSImage imageNamed:@"MiddleVolumeFillerPart"];
        rightFillImage = [NSImage imageNamed:@"RightVolumeFillerPart"];
        
        offset = (knobImage.size.width + 4) / 2;
        [self calculateTick];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    int knobX = (currentValue.floatValue * tick) + offset;
    
    NSDrawThreePartImage(NSMakeRect(2, 0, self.frame.size.width - 4, 16), leftBaseImage, centerBaseImage, rightBaseImage, NO, NSCompositeSourceOver, 1.0, self.isFlipped);
    NSDrawThreePartImage(NSMakeRect(3, 1, knobX, 13), leftFillImage, centerFillImage, rightFillImage, NO, NSCompositeSourceOver, 1.0, self.isFlipped);
    
    [knobImage drawInRect:NSMakeRect(knobX - knobImage.size.width / 2, 0, 16, 16) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
}

@end
