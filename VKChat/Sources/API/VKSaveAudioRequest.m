//
//  VKSaveAudioRequest.m
//  VKChat
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSaveAudioRequest.h"

@implementation VKSaveAudioRequest

@synthesize audio;
@synthesize serverID;
@synthesize hash;
@synthesize artist;
@synthesize title;

- (void)dealloc {
    [audio release];
    [artist release];
    [title release];
    [hash release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.audio = @"";
        self.serverID = -1;
        self.hash = @"";
        self.artist = @"";
        self.title = @"";
    }
    
    return self;
}

- (void)startWithResultBlock:(VKSaveAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"audio.save";
    
    if (audio.length > 0) {
        [self addParamWithKey:@"audio" value:[self.audio stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (self.serverID > 0) {
        [self addParamWithKey:@"server" value:[NSString stringWithFormat:@"%ld", self.serverID]];
    }
    
    [self addParamWithKey:@"hash" value:self.hash];
    
    if (artist.length > 0) {
        [self addParamWithKey:@"artist" value:self.artist];
    }
    
    if (title.length > 0) {
        [self addParamWithKey:@"title" value:self.title];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        VKSong *song = [[VKSong alloc] initWithDictionary:[_response objectForKey:@"response"]];
        
        if (_resultBlock) {
            _resultBlock(song);
        }
    }
}

@end
