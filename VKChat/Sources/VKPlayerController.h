//
//  VKPlayerController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 18.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#import "VKSong.h"
#import "VKSetStatusRequest.h"
#import "AudioStreamer.h"
#import "VKVolumeSlider.h"
#import "VKPlayerSlider.h"
#import "VKPlayerTitleView.h"

@interface VKPlayerController : NSViewController {
    IBOutlet NSButton *playButton;
    IBOutlet NSTextView *titleLabel;
    IBOutlet NSTextField *leftTimeLabel;
    IBOutlet NSTextField *elapsedTimeLabel;
    IBOutlet VKVolumeSlider *volumeSlider;
    IBOutlet NSButton *statusButton;
    IBOutlet NSButton *repeatButton;
    IBOutlet VKPlayerSlider *timeSlider;
    IBOutlet VKPlayerTitleView *titleView;
    VKSong *song;
    BOOL isAddStatus;
    BOOL isRepeat;
    NSTimer *updateTimer;
    AudioStreamer *streamer;
}

@property (nonatomic, assign) NSButton *playButton;
@property (nonatomic, assign) NSTextView *titleLabel;
@property (nonatomic, retain) VKSong *song;

- (void)startPlay;
- (void)stopPlay;

- (IBAction)togglePlay:(id)sender;
- (IBAction)toggleStatusMode:(id)sender;
- (IBAction)toggleRepeatMode:(id)sender;
- (IBAction)volumeDidChanged:(id)sender;
- (IBAction)timeDidChanged:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)prevSong:(id)sender;

@end
