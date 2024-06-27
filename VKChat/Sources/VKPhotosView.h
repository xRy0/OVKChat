//
//  VKPhotosView.h
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKCollectionView.h"
#import "VKPhotosItemView.h"

@class VKPhotosView;

@protocol VKPhotosViewDelegate <NSObject>

- (void)photosView:(VKPhotosView *)view didAcceptImages:(NSArray *)images;

@end

@interface VKPhotosView : VKCollectionView

- (void)addImage:(NSImage *)image;

@end
