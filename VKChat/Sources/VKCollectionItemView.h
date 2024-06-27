//
//  DRThumbView.h
//  Dribbler
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VKCollectionItemView;

@protocol VKCollectionItemViewDelegate <NSObject>

- (void)collectionItemViewDidSelect:(VKCollectionItemView *)view;

@end

@interface VKCollectionItemView : NSView {
    NSTrackingArea *trackingArea;
}

@property (retain) NSImage *image;
@property (retain) id object;
@property (assign) BOOL allowDragging;
@property (assign) id <VKCollectionItemViewDelegate> delegate;

@end
