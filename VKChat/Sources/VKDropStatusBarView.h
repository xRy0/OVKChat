//
//  VKDropStatusBarView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 08.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VKDropStatusBarViewDelegate <NSObject>

- (void)dropStatusBarView:(NSView *)dropView didAcceptedImages:(NSArray *)images;

@end

@interface VKDropStatusBarView : NSView {
    NSImage *icon;
    NSImage *iconSelected;
    NSImage *iconUnread;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, assign) BOOL isUnread;
@property (nonatomic, assign) id <VKDropStatusBarViewDelegate> delegate;

- (void)setHighlightState:(BOOL)state;

@end
