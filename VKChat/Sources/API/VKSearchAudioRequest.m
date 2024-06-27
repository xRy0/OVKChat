//
//  VKAudioSearchRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 25.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSearchAudioRequest.h"

@implementation VKSearchAudioRequest

@synthesize query;
@synthesize autoComplete;
@synthesize sort;
@synthesize isHasLyrics;
@synthesize offset;
@synthesize count;

- (void)dealloc {
    [query release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];

    if (self) {
        self.query = @"";
        self.sort = VKSearchAudioOrderTypeRate;
        self.autoComplete = NO;
        self.isHasLyrics = NO;
        self.offset = -1;
        self.count = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKSearchAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"audio.search";
    
    [self addParamWithKey:@"q" value:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self addParamWithKey:@"sort" value:[NSString stringWithFormat:@"%d", sort]];
        
    if (autoComplete) {
        [self addParamWithKey:@"auto_complete" value:@"1"];
    }
    
    if (isHasLyrics) {
        [self addParamWithKey:@"lyrics" value:@"1"];
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
            for (int i = 1; i < [[[_response objectForKey:@"response"] objectForKey:@"items"] count]; i++) {
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
