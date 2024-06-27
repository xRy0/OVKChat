//
//  VKNewMessageDividerView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 21.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKNewMessageDividerView.h"

@implementation VKNewMessageDividerView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSImage imageNamed:@"new_message_divider"] drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

@end
