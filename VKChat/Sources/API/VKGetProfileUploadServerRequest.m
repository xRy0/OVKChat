//
//  VKGetProfileUploadServerRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 28.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetProfileUploadServerRequest.h"

@implementation VKGetProfileUploadServerRequest

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (void)startWithResultBlock:(VKGetProfileUploadServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"photos.getProfileUploadServer";
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if (_resultBlock) {
            _resultBlock([NSURL URLWithString:[[_response objectForKey:@"response"] objectForKey:@"upload_url"]]);
        }
    }
}

@end
