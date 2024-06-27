//
//  VKPlayerControlsView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPlayerControlsView.h"

@implementation VKPlayerControlsView

- (void)setFrame:(NSRect)frameRect {
    if (self.frame.size.width < 900) {
        [super setFrame:frameRect];
    }
}

@end
