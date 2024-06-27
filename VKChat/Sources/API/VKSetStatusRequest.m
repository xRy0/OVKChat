//
//  VKSetStatusRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSetStatusRequest.h"

@implementation VKSetStatusRequest

@synthesize text;
@synthesize audioID;
@synthesize audioOwnerID;

- (void)dealloc {
    [text release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.text = @"";
        self.audioID = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKSetStatusRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    
    
    if (self.audioID > 0 && self.audioOwnerID > 0) {
        _method = @"audio.beacon";
        [self addParamWithKey:@"aid" value:[NSString stringWithFormat:@"%ld_%ld", self.audioOwnerID, self.audioID]];
    }
    
    if ([self.text length] > 0) {
        _method = @"status.set";
        [self addParamWithKey:@"text" value:[self.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if ([[_response objectForKey:@"response"] intValue] == 1) {
            if (_resultBlock) {
                _resultBlock(text);
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
