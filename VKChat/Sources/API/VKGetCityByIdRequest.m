//
//  VKGetCityByIdRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 27.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetCityByIdRequest.h"

@implementation VKGetCityByIdRequest

@synthesize cityID;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (void)startWithResultBlock:(VKGetCityByIdRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"places.getCityById";
    
    [self addParamWithKey:@"cids" value:[NSString stringWithFormat:@"%ld", cityID]];
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if (_resultBlock) {
            _resultBlock([[[_response objectForKey:@"response"] lastObject] objectForKey:@"name"]);
        }
    }
}

@end
