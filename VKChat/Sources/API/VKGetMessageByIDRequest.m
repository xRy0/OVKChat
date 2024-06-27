//
//  VKGetMessageRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetMessageByIDRequest.h"

@implementation VKGetMessageByIDRequest

@synthesize messageID;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (void)startWithResultBlock:(VKGetMessageByIDRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"messages.getById";
    
    [self addParamWithKey:@"mid" value:[NSString stringWithFormat:@"%ld", messageID]];
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if (_resultBlock) {
            VKMessage *message = [[[VKMessage alloc] initWithDictionary:[[_response objectForKey:@"response"] lastObject]] autorelease];
            _resultBlock(message);
        }
    }
}

@end
