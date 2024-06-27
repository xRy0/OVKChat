//
//  VKGetPhotosRequest.m
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetPhotosRequest.h"

@implementation VKGetPhotosRequest

@synthesize userID;
@synthesize groupID;
@synthesize albumID;
@synthesize offset;
@synthesize limit;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.offset = -1;
        self.limit = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKGetPhotosRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"photos.get";
    
    if (userID > 0) {
        [self addParamWithKey:@"uid" value:[NSString stringWithFormat:@"%ld", userID]];
    }
    
    if (groupID > 0) {
        [self addParamWithKey:@"gid" value:[NSString stringWithFormat:@"%ld", groupID]];
    }
    
    if (albumID > 0) {
        [self addParamWithKey:@"aid" value:[NSString stringWithFormat:@"%ld", albumID]];
    }
    
    if (offset >= 0) {
        [self addParamWithKey:@"offset" value:[NSString stringWithFormat:@"%ld", offset]];
    }
    
    if (limit > 0) {
        [self addParamWithKey:@"limit" value:[NSString stringWithFormat:@"%ld", limit]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        NSMutableArray *photos = [[[NSMutableArray alloc] init] autorelease];
        
        if ([[_response objectForKey:@"response"] isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [[_response objectForKey:@"response"] count]; i++) {
                NSDictionary *dict = [[_response objectForKey:@"response"] objectAtIndex:i];
                VKPhoto *photo = [[VKPhoto alloc] initWithDictionary:dict];
                
                [photos addObject:photo];
                [photo release];
            }
        }
        
        if (_resultBlock) {
            _resultBlock(photos);
        }
    }
}

@end
