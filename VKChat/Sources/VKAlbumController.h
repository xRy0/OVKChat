//
//  VKAlbumController.h
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKTileBackgroundView.h"
#import "VKPhotosView.h"
#import "VKScrollView.h"
#import "VKPhoto.h"
#import "VKAlbum.h"
#import "VKImageController.h"
#import "VKGetUploadServerRequest.h"
#import "ASIFormDataRequest.h"
#import "VKSavePhotosRequest.h"

@interface VKAlbumController : NSViewController <VKCollectionViewDelegate, VKScrollViewDelegate, VKPhotosViewDelegate> {
    IBOutlet VKTileBackgroundView *tileView;
    IBOutlet VKScrollView *scrollView;
    IBOutlet VKPhotosView *photosView;
    VKImageController *imageController;
    NSMutableArray *_uploadingPhotos;
}

@property (retain) VKAlbum *album;

- (void)refresh;

@end
