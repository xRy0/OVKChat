//
//  VKSliderView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 29.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKSliderView : NSView {
    NSNumber *minValue;
    NSNumber *maxValue;
    NSNumber *currentValue;
    NSTrackingArea *trackingArea;
    NSPoint mousePoint;
    BOOL isMouseDown;
    float tick;
    int offset;
    id target;
    SEL action;
    NSImage *knobImage;
    NSImage *leftBaseImage;
    NSImage *centerBaseImage;
    NSImage *rightBaseImage;
    NSImage *leftFillImage;
    NSImage *centerFillImage;
    NSImage *rightFillImage;
}

@property (nonatomic, retain) NSNumber *minValue;
@property (nonatomic, retain) NSNumber *maxValue;
@property (nonatomic, retain) NSNumber *currentValue;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)calculateTick;
- (void)calculateCurrentValue;

@end
