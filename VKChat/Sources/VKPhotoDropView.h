//
//  VKPhotoDropView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VKPhotoDropView;

@protocol VKPhotoDropViewDelegate <NSObject>

- (void)dropView:(NSView *)dropView didAcceptedImages:(NSArray *)images;

@end

@interface VKPhotoDropView : NSView {
    BOOL isDragOver;
}

@property (nonatomic, assign) IBOutlet id <VKPhotoDropViewDelegate> delegate;

@end
