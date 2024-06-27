//
//  VKPhotoController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPhotoController.h"

@implementation VKPhotoController

- (void)awakeFromNib {
    newAlbumController = [[VKNewAlbumController alloc] initWithWindowNibName:@"NewAlbumWindow"];
    [newAlbumController loadWindow];
    
    albumController = [[VKAlbumController alloc] initWithNibName:@"AlbumView" bundle:nil];
    [albumController loadView];
    
    tileView.tile = [NSImage imageNamed:@"BGTile"];

    albumsView.maxCellSize = NSMakeSize(200, 220);
    albumsView.minCellSize = NSMakeSize(200, 220);
    albumsView.offset = DRMakeOffset(20, 20);
    albumsView.maxCellSpace = DRMakeCellSpace(20, 20);
    albumsView.minCellSpace = DRMakeCellSpace(10, 10);
    albumsView.allowDragging = NO;
    albumsView.delegate = self;
    
    albumsView.frame = scrollView.bounds;
    [scrollView setDocumentView:albumsView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:VK_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:VK_NOTIFICATION_UPDATE_ALBUMS object:nil];
}

- (void)refresh {
    [albumsView clear];
    
    __block VKGetAlbumsRequest *request = [[VKGetAlbumsRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.userID = [VKAccessToken userID];

    VKGetAlbumsRequestResultBlock resultBlock = ^(NSArray *albums) {
        [_albums release];
        _albums = [albums retain];
        
        for (__block VKAlbum *album in _albums) {
            [albumsView addItem:album];
            
            __block VKGetPhotosRequest *photosRequest = [[VKGetPhotosRequest alloc] init];
            
            photosRequest.accessToken = [VKAccessToken token];
            photosRequest.userID = [VKAccessToken userID];
            photosRequest.albumID = album.identifier;

            VKGetPhotosRequestResultBlock resultBlock = ^(NSArray *photos) {
                album.images = photos;
                
                if (photos.count > 0) {
                    VKPhoto *photo = [photos lastObject];
                    
                    __block ASIHTTPRequest *imageRequest = [ASIHTTPRequest requestWithURL:photo.urlBig];
                    
                    [imageRequest setCompletionBlock:^(void) {
                        photo.imageBig = [[NSImage alloc] initWithData:imageRequest.responseData];
                        [albumsView setImage:photo.imageBig atIndex:[albums indexOfObject:album]];
                    }];
                    
                    [imageRequest startAsynchronous];
                }
                
                [photosRequest release];
            };
            
            VKRequestFailureBlock failureBlock = ^(NSError *error) {
                NSAlert *alert = [NSAlert alertWithError:error];
                [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
                
                [photosRequest release];
            };
            
            [photosRequest startWithResultBlock:resultBlock failureBlock:failureBlock];
        }

        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)userLogout {
    [albumsView clear];
}

#pragma mark -
#pragma mark VKCollectionViewDelegate
#pragma mark -

- (void)collectionView:(VKCollectionView *)view didSelectItem:(VKCollectionItemView *)itemView {
    VKAlbum *album = (VKAlbum *)itemView.object;

    albumController.view.frame = self.view.bounds;
    [self.view addSubview:albumController.view];
    
    albumController.album = album;
    [albumController refresh];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)addAlbum:(id)sender {
    [NSApp beginSheet:newAlbumController.window modalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

@end
