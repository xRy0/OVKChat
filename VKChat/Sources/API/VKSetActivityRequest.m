//
//  VKSetActivityRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSetActivityRequest.h"

@implementation VKSetActivityRequest

@synthesize userID;
@synthesize type;

- (void)dealloc {
    [type release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.userID = -1;
        self.type = @"typing";
    }
    
    return self;
}

- (void)startWithResultBlock:(VKSetActivityRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"messages.setActivity";
    
    if (userID > 0) {
        [self addParamWithKey:@"uid" value:[NSString stringWithFormat:@"%ld", userID]];
    }
    
    
    [self addParamWithKey:@"type" value:type];
    
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
