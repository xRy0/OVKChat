//
//  VKGetAudioUploadServerRequest
//  VKChat
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetAudioUploadServerRequest.h"

@implementation VKGetAudioUploadServerRequest

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (void)startWithResultBlock:(VKGetAudioUploadServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"audio.getUploadServer";
    
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
