//
//  VKGetAudioRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetAudioRequest.h"

@implementation VKGetAudioRequest

@synthesize userID;
@synthesize groupID;
@synthesize albumID;
@synthesize offset;
@synthesize count;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.offset = -1;
        self.count = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKGetAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"audio.get";
    
    if (userID > 0) {
        [self addParamWithKey:@"owner_id" value:[NSString stringWithFormat:@"%ld", userID]];
    }
    
    if (groupID > 0) {
        [self addParamWithKey:@"gid" value:[NSString stringWithFormat:@"%ld", groupID]];
    }
    
    if (albumID > 0) {
        [self addParamWithKey:@"album_id" value:[NSString stringWithFormat:@"%ld", albumID]];
    }
    
    if (offset >= 0) {
        [self addParamWithKey:@"offset" value:[NSString stringWithFormat:@"%ld", offset]];
    }
    
    if (count > 0) {
        [self addParamWithKey:@"count" value:[NSString stringWithFormat:@"%ld", count]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        NSMutableArray *songs = [[[NSMutableArray alloc] init] autorelease];
        
        if ([[[_response objectForKey:@"response"] objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [[[_response objectForKey:@"response"] objectForKey:@"items"] count]; i++) {
                NSDictionary *dict = [[[_response objectForKey:@"response"] objectForKey:@"items"] objectAtIndex:i];
                VKSong *song = [[VKSong alloc] initWithDictionary:dict];
                
                [songs addObject:song];
                [song release];
            }
        }
        
        if (_resultBlock) {
            _resultBlock(songs);
        }
    }
}

@end
