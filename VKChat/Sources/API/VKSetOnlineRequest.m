//
//  VKSetOnlineRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSetOnlineRequest.h"

@implementation VKSetOnlineRequest

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (void)startWithResultBlock:(VKSetOnlineRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"account.setOnline";
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if ([[_response objectForKey:@"response"] intValue] == 1) {
            if (_resultBlock) {
                _resultBlock();
            }
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:@"" forKey:NSLocalizedDescriptionKey];
            
            _error = [[NSError errorWithDomain:VK_ERROR_DOMAIN code:1000 userInfo:errorDetails] retain];
            
            if (_failureBlock) {
                _failureBlock(_error);
            }
        }        
    }
}

@end
