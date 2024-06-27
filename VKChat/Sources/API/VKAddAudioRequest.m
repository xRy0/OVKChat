//
//  VKAddAudioRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 26.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAddAudioRequest.h"

@implementation VKAddAudioRequest

@synthesize audioID;
@synthesize userID;
@synthesize groupID;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.audioID = -1;
        self.userID = -1;
        self.groupID = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKAddAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"audio.add";
    
    [self addParamWithKey:@"audio_id" value:[NSString stringWithFormat:@"%ld", audioID]];
    [self addParamWithKey:@"owner_id" value:[NSString stringWithFormat:@"%ld", userID]];
    
    if (groupID > 0) {
        [self addParamWithKey:@"gid" value:[NSString stringWithFormat:@"%ld", groupID]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if (_resultBlock) {
            _resultBlock([[_response objectForKey:@"response"] intValue]);
        }
    }
}

@end
