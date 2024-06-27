//
//  VKAlbumsView.m
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAlbumsView.h"

@implementation VKAlbumsView

- (void)addItem:(id)object {
    VKAlbumsItemView *thumbView = [[VKAlbumsItemView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    thumbView.object = object;
    thumbView.delegate = self;
    thumbView.allowDragging = self.allowDragging;
    
    [self addSubview:thumbView];
    [_thumbs addObject:thumbView];
    
    [self resizeGrid];
}

@end
