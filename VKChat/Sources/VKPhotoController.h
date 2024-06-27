//
//  VKPhotoController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKGetAlbumsRequest.h"
#import "VKGetPhotosRequest.h"
#import "ASIFormDataRequest.h"
#import "VKTileBackgroundView.h"
#import "VKNewAlbumController.h"
#import "VKAlbumsView.h"
#import "VKAlbumController.h"

@interface VKPhotoController : NSViewController <VKCollectionViewDelegate> {
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet VKTileBackgroundView *tileView;
    IBOutlet NSTextField *sizeLabel;
    IBOutlet NSScrollView *scrollView;
    IBOutlet VKAlbumsView *albumsView;
    VKNewAlbumController *newAlbumController;
    VKAlbumController *albumController;
    NSArray *_albums;
}

- (void)refresh;

- (IBAction)addAlbum:(id)sender;

@end
