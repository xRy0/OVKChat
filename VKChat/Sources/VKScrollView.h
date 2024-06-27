//
//  DRScrollView.h
//  Dribbler
//
//  Created by Sergey Lenkov on 22.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VKScrollView;

@protocol VKScrollViewDelegate <NSObject>

- (void)scrollViewDidScrollToBottom:(VKScrollView *)scrollView;

@end

@interface VKScrollView : NSScrollView

@property (assign) id <VKScrollViewDelegate> delegate;

@end
