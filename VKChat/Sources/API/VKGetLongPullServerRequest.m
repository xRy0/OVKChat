//
//  VKGetLongPullServerRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 27.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetLongPullServerRequest.h"

@implementation VKGetLongPullServerRequest

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (void)startWithResultBlock:(VKGetLongPullServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"messages.getLongPollServer";
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if (_resultBlock) {
            _resultBlock([[_response objectForKey:@"response"] objectForKey:@"server"], [[_response objectForKey:@"response"] objectForKey:@"key"], [[[_response objectForKey:@"response"] objectForKey:@"ts"] intValue]);
        }
    }
}

@end
