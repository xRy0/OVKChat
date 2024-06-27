//
//  VKSendMessageRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSendMessageRequest.h"

@implementation VKSendMessageRequest

@synthesize userID;
@synthesize message;
@synthesize captchaID;
@synthesize captchaKey;

- (void)dealloc {
    [message release];
    [captchaKey release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.userID = -1;
        self.message = @"";
        self.captchaID = -1;
        self.captchaKey = @"";
    }
    
    return self;
}

- (void)startWithResultBlock:(VKSendMessageRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"messages.send";
    
    if (self.userID > 0) {
        [self addParamWithKey:@"uid" value:[NSString stringWithFormat:@"%ld", self.userID]];
    }
    
    
    [self addParamWithKey:@"message" value:[self.message stringByEscapingForURLArgument]];
    
    if (self.captchaID > 0) {
        [self addParamWithKey:@"captcha_sid" value:[NSString stringWithFormat:@"%ld", self.captchaID]];
        [self addParamWithKey:@"captcha_key" value:[self.captchaKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
