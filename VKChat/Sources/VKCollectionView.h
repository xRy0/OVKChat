//
//  VKCollectionView.h
//  VKChat
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKCollectionItemView.h"

typedef struct _DROffset {
    CGFloat x;
    CGFloat y;
} DROffset;

NS_INLINE DROffset DRMakeOffset(CGFloat x, CGFloat y) {
    DROffset o;
    o.x = x;
    o.y = y;
    return o;
}

typedef struct _DRCellSpace {
    CGFloat x;
    CGFloat y;
} DRCellSpace;

NS_INLINE DRCellSpace DRMakeCellSpace(CGFloat x, CGFloat y) {
    DRCellSpace o;
    o.x = x;
    o.y = y;
    return o;
}

@class VKCollectionView;

@protocol VKCollectionViewDelegate <NSObject>

- (void)collectionView:(VKCollectionView *)view didSelectItem:(VKCollectionItemView *)itemView;

@end

@interface VKCollectionView : NSView <VKCollectionItemViewDelegate> {
    NSMutableArray *_thumbs;
}

@property (assign) NSSize maxCellSize;
@property (assign) NSSize minCellSize;
@property (assign) DROffset offset;
@property (assign) DRCellSpace maxCellSpace;
@property (assign) DRCellSpace minCellSpace;
@property (assign) BOOL allowDragging;
@property (assign) id <VKCollectionViewDelegate> delegate;

- (void)clear;
- (void)addItem:(id)object;
- (void)setImage:(NSImage *)image forObject:(id)object;
- (void)setImage:(NSImage *)image atIndex:(NSInteger)index;
- (void)removeItemWithObject:(id)object;
- (void)resizeGrid;

@end
