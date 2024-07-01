//
//  VKAudioController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAudioController.h"
#import "VKAppDelegate.h"

@implementation VKAudioController

- (void)dealloc {
    [_songs release];
    [addedSongs release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib {
    isSongLoaded = NO;
    isRequestInProgress = NO;
    
    addedSongs = [[NSMutableDictionary alloc] init];
	_songs = [[NSMutableArray alloc] init];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextSong) name:VK_NOTIFICATION_NEXT_SONG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playPrevSong) name:VK_NOTIFICATION_PREV_SONG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:VK_NOTIFICATION_LOGOUT object:nil];
}

- (void)refresh {
    if (!isSongLoaded) {
        [progressIndicator startAnimation:nil];
    }
	
    [_songs removeAllObjects];
    
	__block VKGetAudioRequest *request = [[VKGetAudioRequest alloc] init];
        
	request.accessToken = [VKAccessToken token];
	request.userID = [VKAccessToken userID];

	VKGetAudioRequestResultBlock resultBlock = ^(NSArray *songs) {
		for (VKSong *song in songs) {
			if (![self isSongExists:song]) {
				[_songs addObject:song];
			}
		}
			
		[_songs sortUsingSelector:@selector(compareIdentifier:)];
            
		isSongLoaded = YES;
		[progressIndicator stopAnimation:nil];
            
		[listView reloadData];
            
		[request release];
	};
        
	VKRequestFailureBlock failureBlock = ^(NSError *error) {
		[progressIndicator stopAnimation:nil];
		[request release];
	};
        
	[request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (BOOL)isSongExists:(VKSong *)song {
	for (VKSong *_song in _songs) {
		if (song.uidentifier == _song.uidentifier) {
			return YES;
		}
	}
	
	return NO;
}

- (void)setSearchFieldHidden:(BOOL)hidden {
    if (hidden) {
        [searchField removeFromSuperview];
    } else {
        VKAppDelegate *app = (VKAppDelegate *)[NSApp delegate];
        
        searchField.frame = NSMakeRect(app.window.frame.size.width - 210, 16, 200, 22);
        [app.window.titleBarView addSubview:searchField];
    }
}

- (void)playNextSong {
    if (selectedSongIndex < [_songs count] - 1) {
        [self playSongAtIndex:selectedSongIndex + 1];
    }
}

- (void)playPrevSong {
    if (selectedSongIndex > 0) {
        [self playSongAtIndex:selectedSongIndex - 1];
    }
}

- (void)playSongAtIndex:(NSInteger)index {
    selectedSong = [_songs objectAtIndex:index];
    selectedSongIndex = index;
    
    if (selectedSong) {
        [listView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SONG object:selectedSong];
    }
}

- (void)userLogout {
    isSongLoaded = NO;
    
    [_songs removeAllObjects];
    [listView reloadData];
}

- (void)clearUploads {
    NSMutableArray *temp = [NSMutableArray array];
    
    for (id _song in _songs) {
        if ([_song isKindOfClass:[NSString class]]) {
            [temp addObject:_song];
        }
    }
    
    for (id song in temp) {
        [_songs removeObject:_songs];
    }
    
    [listView reloadData];
}

- (void)uploadFile {
    for (__block id _song in _songs) {
        if ([_song isKindOfClass:[NSString class]]) {
            __block VKGetAudioUploadServerRequest *request = [[VKGetAudioUploadServerRequest alloc] init];
            request.accessToken = [VKAccessToken token];
            
            VKGetAudioUploadServerRequestResultBlock resultBlock = ^(NSURL *url) {
                NSInteger index = [_songs indexOfObject:_song];
                VKAudioCell *cell = (VKAudioCell *)[listView cellForRowAtIndex:index];
                [cell.progressIndicator setIndeterminate:NO];
                
                __block ASIFormDataRequest *post = [ASIFormDataRequest requestWithURL:url];
                post.timeOutSeconds = 180;

                NSData *data = [NSData dataWithContentsOfFile:_song];
                
                [post addData:data withFileName:[_song lastPathComponent] andContentType:@"audio/mpeg" forKey:@"file"];
                
                [post setCompletionBlock:^() {
                    id response = [post.responseString JSONValue];

                    if ([response objectForKey:@"audio"]) {
                        __block VKSaveAudioRequest *save = [[VKSaveAudioRequest alloc] init];
                        
                        save.accessToken = [VKAccessToken token];
                        save.audio = [response objectForKey:@"audio"];
                        save.serverID = [[response objectForKey:@"server"] intValue];
                        save.hash = [response objectForKey:@"hash"];

                        VKSaveAudioRequestResultBlock resultBlock = ^(VKSong *song) {
                            NSInteger index = [_songs indexOfObject:_song];
                            [_songs replaceObjectAtIndex:index withObject:song];

                            [listView reloadData];
                            
                            [save release];
                        };
                        
                        VKRequestFailureBlock failureBlock = ^(NSError *error) {
                            [self clearUploads];
                            
                            NSAlert *alert = [NSAlert alertWithError:error];
                            [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
                            
                            [save release];
                        };
                        
                        [save startWithResultBlock:resultBlock failureBlock:failureBlock];
                    } else {
                        [self clearUploads];
                    }
                }];
                
                [post setFailedBlock:^{
                    [self clearUploads];
                    
                    NSAlert *alert = [NSAlert alertWithError:post.error];
                    [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
                }];
                
                [post setBytesSentBlock:^(unsigned long long bytes, unsigned long long total) {
                    NSInteger index = [_songs indexOfObject:_song];
                    VKAudioCell *cell = (VKAudioCell *)[listView cellForRowAtIndex:index];
                    
                    [cell.progressIndicator setMinValue:0];
                    [cell.progressIndicator setMaxValue:total];
                    [cell.progressIndicator incrementBy:bytes];
                }];
                
                [post startAsynchronous];
                
                [request release];
            };
            
            VKRequestFailureBlock failureBlock = ^(NSError *error) {
                [self clearUploads];
                
                NSAlert *alert = [NSAlert alertWithError:error];
                [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
                
                [request release];
            };
            
            [request startWithResultBlock:resultBlock failureBlock:failureBlock];
        }
    }
}

#pragma mark -
#pragma mark PXListViewDelegate
#pragma mark -

- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView {
    return [_songs count];
}

- (PXListViewCell*)listView:(PXListView *)aListView cellForRow:(NSUInteger)row {
    VKAudioCell *cell = (VKAudioCell *)[aListView dequeueCellWithReusableIdentifier:@"AUDIO"];
        
    if (!cell) {
        cell = [[VKAudioCell alloc] initWithReusableIdentifier:@"AUDIO"];
    }
    
    if ([[_songs objectAtIndex:row] isKindOfClass:[VKSong class]]) {
        VKSong *song = [_songs objectAtIndex:row];
        
        cell.artist = song.artist;
        cell.title = song.title;
        cell.duration = [[NSNumber numberWithInt:song.duration] durationFormatWithMinutes];
        cell.isCanAdd = NO;
        cell.isPlayed = NO;
        cell.isUpload = NO;
        
        cell.addTarget = self;
        cell.addAction = @selector(rowDidClicked:);
        
        if (song.identifier == selectedSong.identifier) {
            cell.isPlayed = YES;
        }
        
        if ([searchField.stringValue length] > 0 && ![addedSongs objectForKey:[NSString stringWithFormat:@"%ld", song.identifier]]) {
            cell.isCanAdd = YES;
        }
    } else {
        NSString *file = [_songs objectAtIndex:row];
        
        cell.title = [file lastPathComponent];
        cell.artist = @"";
        cell.duration = @"";
        cell.isUpload = YES;
        cell.isPlayed = NO;
        cell.isCanAdd = NO;
        cell.addTarget = nil;
        cell.addAction = nil;
    }
    
	return cell;
}

- (CGFloat)listView:(PXListView *)aListView heightOfRow:(NSUInteger)row {
	return 42;
}

- (void)listView:(PXListView*)aListView rowDoubleClicked:(NSUInteger)rowIndex {
    [self playSongAtIndex:rowIndex];
}

#pragma mark -
#pragma mark VKAudioDropView
#pragma mark -

- (void)dropView:(NSView *)dropView didAcceptFiles:(NSArray *)files {
    NSLog(@"%@", files);
    for (NSString *file in files) {
        [_songs insertObject:file atIndex:0];
    }
    
    [listView reloadData];
    [self uploadFile];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)rowDidClicked:(id)sender {
    VKAudioCell *cell = (VKAudioCell *)sender;
    NSInteger index = cell.row;
    
    if (index != -1) {
        VKSong *song = [_songs objectAtIndex:index];

        __block VKAddAudioRequest *request = [[VKAddAudioRequest alloc] init];
        
        request.accessToken = [VKAccessToken token];
        request.audioID = song.identifier;
        request.userID = song.userID;
        
        VKAddAudioRequestResultBlock resultBlock = ^(NSInteger audioID) {
            [addedSongs setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld", song.identifier]];
            isSongLoaded = NO;
            
            [listView reloadData];
            
            [request release];
        };
        
        VKRequestFailureBlock failureBlock = ^(NSError *error) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert beginSheetModalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            
            [request release];
        };
        
        [request startWithResultBlock:resultBlock failureBlock:failureBlock];
    }
}

- (IBAction)search:(id)sender {
    if ([searchField.stringValue length] == 0) {
        isSongLoaded = NO;
        [self refresh];
    } else if (!isRequestInProgress) {
        isRequestInProgress = YES;
    
        __block VKSearchAudioRequest *request = [[VKSearchAudioRequest alloc] init];
        
        request.accessToken = [VKAccessToken token];
        request.query = searchField.stringValue;
        request.offset = 0;
        request.count = 200;
        
        VKSearchAudioRequestResultBlock resultBlock = ^(NSArray *songs) {
            isRequestInProgress = NO;
            [progressIndicator stopAnimation:nil];

            [_songs removeAllObjects];
            [_songs addObjectsFromArray:songs];
            
            [listView reloadData];
            [listView scrollToRow:0];
            
            [request release];
        };
        
        VKRequestFailureBlock failureBlock = ^(NSError *error) {
            isRequestInProgress = NO;
            [progressIndicator stopAnimation:nil];
            
            [_songs removeAllObjects];
            
            [listView reloadData];
            
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert beginSheetModalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            
            [request release];
        };
        
        [request startWithResultBlock:resultBlock failureBlock:failureBlock];
    }   
}

@end
