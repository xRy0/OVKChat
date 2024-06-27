//
//  VKAudioController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKAudioCell.h"
#import "VKSong.h"
#import "VKGetAudioRequest.h"
#import "VKSearchAudioRequest.h"
#import "VKAddAudioRequest.h"
#import "PXListView.h"
#import "VKGetAudioUploadServerRequest.h"
#import "VKSaveAudioRequest.h"

@interface VKAudioController : NSViewController <PXListViewDelegate> {
    IBOutlet PXListView *listView;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSSearchField *searchField;
    NSMutableArray *_songs;
    NSInteger selectedSongIndex;
    VKSong *selectedSong;
    BOOL isRequestInProgress;
    BOOL isSongLoaded;
    NSMutableDictionary *addedSongs;
    NSMutableArray *_uploadingSongs;
    NSInteger currentUploadIndex;
}

- (void)refresh;
- (void)setSearchFieldHidden:(BOOL)hidden;

- (IBAction)search:(id)sender;

@end
