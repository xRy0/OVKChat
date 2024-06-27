//
//  VKGetUploadServer.m
//  VKMessages
//
//  Created by Sergey Lenkov on 24.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetUploadServerRequest.h"

@implementation VKGetUploadServerRequest

@synthesize albumID;
@synthesize groupID;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.albumID = -1;
        self.groupID = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKGetUploadServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"photos.getUploadServer";
    
    if (self.albumID > 0) {
        [self addParamWithKey:@"aid" value:[NSString stringWithFormat:@"%ld", self.albumID]];
    }
    
    if (self.groupID > 0) {
        [self addParamWithKey:@"gid" value:[NSString stringWithFormat:@"%ld", self.groupID]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if (_resultBlock) {
            _resultBlock([NSURL URLWithString:[[_response objectForKey:@"response"] objectForKey:@"upload_url"]], [[[_response objectForKey:@"response"] objectForKey:@"aid"] intValue]);
        }
    }
}

@end
