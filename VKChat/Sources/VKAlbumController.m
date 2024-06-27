//
//  VKAlbumController.m
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAlbumController.h"

@implementation VKAlbumController

@synthesize album;

- (void)dealloc {
    [album release];
    [imageController release];
    [_uploadingPhotos release];
    
    [super dealloc];
}

- (void)awakeFromNib {
    imageController = [[VKImageController alloc] initWithWindowNibName:@"ImageWindow"];
    [imageController loadWindow];
    
    tileView.tile = [NSImage imageNamed:@"BGTile"];
    
    photosView.maxCellSize = NSMakeSize(200, 200);
    photosView.minCellSize = NSMakeSize(200, 200);
    photosView.offset = DRMakeOffset(20, 20);
    photosView.maxCellSpace = DRMakeCellSpace(20, 20);
    photosView.minCellSpace = DRMakeCellSpace(10, 10);
    photosView.allowDragging = YES;
    photosView.delegate = self;
    
    photosView.frame = scrollView.bounds;
    [scrollView setDocumentView:photosView];
    
    scrollView.delegate = self;
    
    _uploadingPhotos = [[NSMutableArray alloc] init];
}

- (void)refresh {
    [photosView clear];
    
    for (__block VKPhoto *photo in album.images) {
        [photosView addItem:photo];

        __block ASIHTTPRequest *imageRequest = [ASIHTTPRequest requestWithURL:photo.urlBig];
        
        [imageRequest setCompletionBlock:^(void) {
            photo.imageBig = [[NSImage alloc] initWithData:imageRequest.responseData];
            [photosView setImage:photo.imageBig atIndex:[album.images indexOfObject:photo]];
        }];
        
        [imageRequest startAsynchronous];
    }
}

- (void)uploadPhotos {
    if ([_uploadingPhotos count] == 0) {
        return;
    }
    
    __block VKGetUploadServerRequest *request = [[VKGetUploadServerRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.albumID = album.identifier;
    
    VKGetUploadServerRequestResultBlock resultBlock = ^(NSURL *url, NSInteger albumID) {
        __block ASIFormDataRequest *post = [ASIFormDataRequest requestWithURL:url];
        post.timeOutSeconds = 180;
		
        __block NSImage *image = [_uploadingPhotos objectAtIndex:0];
        NSBitmapImageRep *imgRep = [[image representations] objectAtIndex:0];
        NSData *data = [imgRep representationUsingType:NSJPEGFileType properties:nil];
        
        [post addData:data withFileName:@"file1.png" andContentType:@"image/png" forKey:@"file1"];
        
        [post setCompletionBlock:^() {
            id response = [post.responseString JSONValue];
            
            if ([response objectForKey:@"photos_list"]) {
                __block VKSavePhotosRequest *save = [[VKSavePhotosRequest alloc] init];
                
                save.accessToken = [VKAccessToken token];
                save.albumID = [[response objectForKey:@"aid"] intValue];
                save.serverID = [[response objectForKey:@"server"] intValue];
                save.photosList = [response objectForKey:@"photos_list"];
                save.hash = [response objectForKey:@"hash"];
                
                VKSavePhotoRequestResultBlock resultBlock = ^(NSArray *photos) {
                    [_uploadingPhotos removeObject:image];
                    [photosView removeItemWithObject:image];
                    
                    [photosView addItem:[photos lastObject]];
                    [photosView setImage:image forObject:[photos lastObject]];
                    
                    if ([_uploadingPhotos count] > 0) {
                        [self uploadPhotos];
                    }
                    
                    [save release];
                };
                
                VKRequestFailureBlock failureBlock = ^(NSError *error) {
                    NSAlert *alert = [NSAlert alertWithError:error];
                    [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
                    
                    [save release];
                };
                
                [save startWithResultBlock:resultBlock failureBlock:failureBlock];
            }
        }];
        
        [post setBytesSentBlock:^(unsigned long long bytes, unsigned long long total) {
            NSLog(@"%lld %lld", bytes, total);
        }];
        
        [post setFailedBlock:^{
            NSAlert *alert = [NSAlert alertWithError:post.error];
            [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        }];
        
        [post startAsynchronous];
        
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

#pragma mark -
#pragma mark VKPhotoViewDelegate
#pragma mark -

- (void)collectionView:(VKPhotosView *)view didSelectItem:(VKCollectionItemView *)itemView {
    VKPhoto *photo = (VKPhoto *)itemView.object;

    [imageController showWindow:nil];
    [imageController.window makeKeyAndOrderFront:nil];
    
    imageController.photo = photo;
}

- (void)photosView:(VKPhotosView *)view didAcceptImages:(NSArray *)images {
    for (NSImage *image in images) {
        [_uploadingPhotos addObject:image];
        [photosView addImage:image];
    }
    
    [self uploadPhotos];
}

#pragma mark -
#pragma mark VKScrollViewDelegate
#pragma mark -

- (void)scrollViewDidScrollToBottom:(VKScrollView *)scrollView {
    
}

@end
