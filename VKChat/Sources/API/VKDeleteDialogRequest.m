//
//  VKDeleteDialogRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDeleteDialogRequest.h"

@implementation VKDeleteDialogRequest

@synthesize userID;
@synthesize offset;
@synthesize limit;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.userID = -1;
        self.offset = -1;
        self.limit = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKDeleteDialogRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"messages.deleteDialog";
    
    if (self.userID > 0) {
        [self addParamWithKey:@"uid" value:[NSString stringWithFormat:@"%ld", self.userID]];
    }
    
    if (self.offset >= 0) {
        [self addParamWithKey:@"offset" value:[NSString stringWithFormat:@"%ld", self.offset]];
    }
    
    if (self.limit > 0) {
        [self addParamWithKey:@"limit" value:[NSString stringWithFormat:@"%ld", self.limit]];
    }
    
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
