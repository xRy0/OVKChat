//
//  VKCollectionView.m
//  VKChat
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKCollectionView.h"

@implementation VKCollectionView

@synthesize maxCellSize;
@synthesize minCellSize;
@synthesize offset;
@synthesize maxCellSpace;
@synthesize minCellSpace;
@synthesize allowDragging;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        _thumbs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)clear {
    [_thumbs makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_thumbs removeAllObjects];
}

- (void)addItem:(id)object {
    VKCollectionItemView *thumbView = [[VKCollectionItemView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    thumbView.object = object;
    thumbView.delegate = self;
    thumbView.allowDragging = allowDragging;
    
    [self addSubview:thumbView];
    [_thumbs addObject:thumbView];
    
    [self resizeGrid];
}

- (void)setImage:(NSImage *)image forObject:(id)object {
    for (VKCollectionItemView *thumbView in _thumbs) {
        if (object == thumbView.object) {
            thumbView.image = image;
            [thumbView setNeedsDisplay:YES];
            
            break;
        }
    }
}

- (void)setImage:(NSImage *)image atIndex:(NSInteger)index {
    VKCollectionItemView *thumbView = [_thumbs objectAtIndex:index];
    thumbView.image = image;
    
    [thumbView setNeedsDisplay:YES];
}

- (void)removeItemWithObject:(id)object {
    for (VKCollectionItemView *thumbView in _thumbs) {
        if (object == thumbView.object) {
            [thumbView removeFromSuperview];
            [_thumbs removeObject:thumbView];
            
            [self resizeGrid];
            
            break;
        }
    }
}

- (void)resizeGrid {
    int cellsInRow = (self.frame.size.width - (offset.y * 2)) / maxCellSize.width;
    int x = offset.x;
    int y = offset.y;
    int column = 0;
    int row = 0;
    int width = maxCellSize.width;
    int height = maxCellSize.height;
    int index = 0;
    
    for (VKCollectionItemView *thumbView in _thumbs) {
        thumbView.frame = NSMakeRect(x, y, width, height);
        
        x = x + width + minCellSpace.x;
        column++;
        
        if (column == cellsInRow && index < [_thumbs count]) {
            column = 0;
            row++;
            x = offset.x;
            y = y + height + minCellSpace.y;
        }
        
        index++;
    }
    
    [self setFrameSize:NSMakeSize(self.frame.size.width, y + height + offset.y)];
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    [self resizeGrid];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)collectionItemViewDidSelect:(VKCollectionItemView *)view {
    if (delegate && [delegate respondsToSelector:@selector(collectionView: didSelectItem:)]) {
        [delegate collectionView:self didSelectItem:view];
    }
}

@end
