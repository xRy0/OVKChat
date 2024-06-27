//
//  VKPhotoUploadView.m
//  VKMessages
//
//  Created by Sergey Lenkov on 03.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPhotoUploadView.h"

@implementation VKPhotoUploadView

@synthesize images;

- (void)dealloc {
    [images release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSInteger columns = VK_PHOTO_UPLOAD_COLUMNS;
    NSInteger rows = 0;
    
    if ([self.images count] < columns) {
        columns = [self.images count];
    }

    rows = ceil((float)[self.images count] / (float)columns);
    
    int x = 0;
    int y = 0;
    int cellSize = self.frame.size.width / columns;
    int offsetY = 0;
    int offsetX = 0;
    
    offsetX = (self.frame.size.width - (cellSize * columns)) / 2;
    
    x = offsetX;
    y = offsetY;
    
    int totalHeight = 0;
    
    for (int row = 0; row < rows; row++) {
        int height = 0;
        
        for (int column = 0; column < columns; column++) {
            NSInteger i = (row * columns) + column;

            if (i < [self.images count]) {
                NSImage *image = [self.images objectAtIndex:i];
                
                float scale = 1.0;
                
                if (image.size.width > cellSize) {
                    scale = cellSize / image.size.width;
                }

                int scaledHeight = image.size.height * scale;

                if (scaledHeight > height) {
                    height = scaledHeight;
                }
            }
        }

        totalHeight = totalHeight + height + 12;
    }
    
    if (totalHeight > self.superview.frame.size.height) {
        self.frame = NSMakeRect(0, 0, self.frame.size.width, totalHeight);
    }
    
    x = offsetX;
    y = 0;
    
    if (totalHeight < self.superview.frame.size.height) {
        offsetY = (self.superview.frame.size.height - totalHeight) / 2;
    }
  
    for (int row = 0; row < rows; row++) {
        int height = 0;
        
        for (int column = 0; column < columns; column++) {
            NSInteger i = (row * columns) + column;
            
            if (i < [self.images count]) {
                NSImage *image = [self.images objectAtIndex:i];
                
                float scale = 1.0;
                
                if (image.size.width > cellSize) {
                    scale = cellSize / image.size.width;
                }
                
                int scaledHeight = image.size.height * scale;

                if (scaledHeight > height) {
                    height = scaledHeight;
                }
            }
        }
        
        height = height + 12;
        
        for (int column = 0; column < columns; column++) {
            NSInteger i = (row * columns) + column;

            if (i < [self.images count]) {
                NSImage *image = [self.images objectAtIndex:i];
                
                float scale = 1.0;
                
                if (image.size.width > cellSize - 20) {
                    scale = (cellSize - 20) / image.size.width;
                }
                
                int scaledWidth = image.size.width * scale;
                int scaledHeight = image.size.height * scale;

                int _x = x + (((cellSize - 20) - scaledWidth) / 2);
                int _y = y + offsetY + (height - scaledHeight) / 2;
                
                NSRect rect = NSMakeRect(_x, _y, scaledWidth + 12, scaledHeight + 12);
                
                NSDrawNinePartImage(rect, [NSImage imageNamed:@"LeftTopEnd"], [NSImage imageNamed:@"TopEnd"], [NSImage imageNamed:@"RightTopEnd"],
                                          [NSImage imageNamed:@"LeftMiddleEnd"], [NSImage imageNamed:@"CenterMiddle"], [NSImage imageNamed:@"RightMiddleEnd"],
                                          [NSImage imageNamed:@"LeftBottomEnd"], [NSImage imageNamed:@"BottomEnd"], [NSImage imageNamed:@"RightBottomEnd"], NSCompositeSourceOver, 1.0, self.isFlipped);
                
                rect = NSMakeRect(_x + 10, _y + 8, scaledWidth - 8, scaledHeight - 8);
                [image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];

                x = x + cellSize;
            }
        }

        x = offsetX;
        y = y + height;
    }
}

- (BOOL)isFlipped {
    return YES;
}

@end
