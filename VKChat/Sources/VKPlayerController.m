//
//  VKPlayerController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 18.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPlayerController.h"

@implementation VKPlayerController

@synthesize playButton;
@synthesize titleLabel;
@synthesize song;

- (void)dealloc {
    [self stopPlay];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)awakeFromNib {
    isAddStatus = NO;
    [statusButton setImage:[NSImage imageNamed:@"AddMusicToStatusIconStandby"]];
    
    isRepeat = NO;
    [repeatButton setImage:[NSImage imageNamed:@"RepeatIconStandby"]];
    
    volumeSlider.target = self;
    volumeSlider.action = @selector(volumeDidChanged:);
    
    volumeSlider.minValue = [NSNumber numberWithInt:0];
    volumeSlider.maxValue = [NSNumber numberWithInt:100];
    volumeSlider.currentValue = [NSNumber numberWithInt:[VKSettings volume]];
    
    timeSlider.target = self;
    timeSlider.action = @selector(timeDidChanged:);
    
    timeSlider.minValue = [NSNumber numberWithInt:0];
    timeSlider.maxValue = [NSNumber numberWithInt:0];
    timeSlider.currentValue = [NSNumber numberWithInt:0];
    
    [titleLabel setEditable:NO];
    [titleLabel setSelectable:YES];
    titleLabel.font = [NSFont fontWithName:VK_FONT_PLAYER_TITLE size:VK_FONT_SIZE_PLAYER_TITLE];
    titleLabel.textColor = [NSColor whiteColor];
    [titleLabel setTextContainerInset:NSZeroSize];
    
    elapsedTimeLabel.stringValue = [[NSNumber numberWithInt:0] durationFormatWithMinutes];
    leftTimeLabel.stringValue = [[NSNumber numberWithInt:0] durationFormatWithMinutes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:VK_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songDidSelected:) name:VK_NOTIFICATION_SONG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(togglePlay:) name:VK_NOTIFICATION_PLAY_SONG object:nil];
}

- (void)setSong:(VKSong *)newSong {
    [song release];
    song = [newSong retain];
    
    titleView.artist = song.artist;
    titleView.title = song.title;
    
    [titleView setNeedsDisplay:YES];
    
    if (streamer) {
        [streamer stop];
        [streamer release];
        streamer = nil;
    }
    
    streamer = [[AudioStreamer alloc] initWithURL:song.url];
    
    if ([VKSettings audioDevice]) {
        //streamer.outputDevice = @"AppleUSBAudioEngine:M-Audio:Fast Track:1d140000:2,1";
        streamer.outputDevice = [VKSettings audioDevice];
    }
    
    timeSlider.minValue = [NSNumber numberWithInt:0];
    timeSlider.maxValue = [NSNumber numberWithInt:song.duration];
    timeSlider.currentValue = [NSNumber numberWithInt:0];
    
    elapsedTimeLabel.stringValue = [[NSNumber numberWithInt:song.duration] durationFormatWithMinutes];
    leftTimeLabel.stringValue = [[NSNumber numberWithInt:0] durationFormatWithMinutes];
    
    [self togglePlay:nil];
}

- (void)songDidSelected:(NSNotification *)notification {
    self.song = [notification object];
}

- (void)updateTime {
    leftTimeLabel.stringValue = [[NSNumber numberWithDouble:streamer.progress] durationFormatWithMinutes];
    elapsedTimeLabel.stringValue = [NSString stringWithFormat:@"-%@", [[NSNumber numberWithDouble:streamer.duration - streamer.progress] durationFormatWithMinutes]];
    
    timeSlider.currentValue = [NSNumber numberWithDouble:streamer.progress];
}

- (void)startPlay {
    updateTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES] retain];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:streamer];

    [streamer start];    
    
    [self setStatus];
}

- (void)setStatus {
    if (isAddStatus) {
        __block VKSetStatusRequest *request = [[VKSetStatusRequest alloc] init];
        
        request.accessToken = [VKAccessToken token];
        request.audioOwnerID = song.userID;
        request.audioID = song.identifier;
        request.userID = [VKAccessToken userID];
        
        VKSetStatusRequestResultBlock resultBlock = ^(NSString *status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_UPDATE_STATUS object:nil];
            [request release];
        };
        
        VKRequestFailureBlock failureBlock = ^(NSError *error) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
            
            [request release];
        };
        
        [request startWithResultBlock:resultBlock failureBlock:failureBlock];
    }
}

- (void)stopPlay {
    if (streamer) {
		[streamer pause];
        
        [updateTimer invalidate];
        [updateTimer release];
        updateTimer = nil;
        
        [playButton setImage:[NSImage imageNamed:@"PlayButtonStandby"]];
        [playButton setAlternateImage:[NSImage imageNamed:@"PlayButtonPressed"]];
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification {
	if ([streamer isWaiting]) {
		//
	} else if ([streamer isPlaying]) {
		[playButton setImage:[NSImage imageNamed:@"PauseButtonStandby"]];
        [playButton setAlternateImage:[NSImage imageNamed:@"PauseButtonPressed"]];
        
        [streamer setVolume:volumeSlider.currentValue.floatValue / 100.0];
	} else if ([streamer isIdle]) {
        if (isRepeat) {
            self.song = song;
        } else {
            if (streamer.stopReason == AS_STOPPING_EOF) {
                [self nextSong:nil];
            } else {
                [self stopPlay];
            }
        }
	}
}

- (void)userLogout {
    [self stopPlay];
	
	titleView.artist = @"";
	titleView.title = @"";
	
	[titleView setNeedsDisplay:YES];
	
	timeSlider.minValue = [NSNumber numberWithInt:0];
    timeSlider.maxValue = [NSNumber numberWithInt:song.duration];
    timeSlider.currentValue = [NSNumber numberWithInt:0];
    
    elapsedTimeLabel.stringValue = [[NSNumber numberWithInt:song.duration] durationFormatWithMinutes];
    leftTimeLabel.stringValue = [[NSNumber numberWithInt:0] durationFormatWithMinutes];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)togglePlay:(id)sender {
    if ([streamer isPlaying]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASStatusChangedNotification object:streamer];
        [self stopPlay];
    } else {
        if (streamer && streamer.stopReason == AS_STOPPING_ERROR) {
            self.song = song;
        }
        
        [self startPlay];
    }
}

- (IBAction)volumeDidChanged:(id)sender {
    [VKSettings setVolume:volumeSlider.currentValue.intValue];
    
    float val = volumeSlider.currentValue.floatValue / 100.0;
 
    if (streamer) {
        [streamer setVolume:val];
    }
}

- (IBAction)toggleStatusMode:(id)sender {
    isAddStatus = !isAddStatus;

    if (isAddStatus) {
		[self setStatus];
        [statusButton setImage:[NSImage imageNamed:@"AddMusicToStatusIconPressed"]];
    } else {
        [statusButton setImage:[NSImage imageNamed:@"AddMusicToStatusIconStandby"]];
    }
}

- (IBAction)toggleRepeatMode:(id)sender {
    isRepeat = !isRepeat;
    
    if (isRepeat) {
        [repeatButton setImage:[NSImage imageNamed:@"RepeatIconPressed"]];
    } else {
        [repeatButton setImage:[NSImage imageNamed:@"RepeatIconStandby"]];
    }
}

- (IBAction)timeDidChanged:(id)sender {
    [streamer seekToTime:timeSlider.currentValue.floatValue];
}

- (IBAction)nextSong:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_NEXT_SONG object:nil];
}

- (IBAction)prevSong:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_PREV_SONG object:nil];
}

@end
