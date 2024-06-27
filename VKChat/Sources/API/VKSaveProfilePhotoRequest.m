//
//  VKSaveProfilePhotoRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 28.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSaveProfilePhotoRequest.h"

@implementation VKSaveProfilePhotoRequest

@synthesize serverID;
@synthesize photo;
@synthesize hash;

- (void)dealloc {
    [photo release];
    [hash release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.serverID = -1;
        self.hash = @"";
    }
    
    return self;
}

- (void)startWithResultBlock:(VKSaveProfilePhotoRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"photos.saveProfilePhoto";

    if (serverID > 0) {
        [self addParamWithKey:@"server" value:[NSString stringWithFormat:@"%ld", serverID]];
    }
    
    [self addParamWithKey:@"photo" value:[photo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self addParamWithKey:@"hash" value:hash];
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        if (_resultBlock) {
            _resultBlock([[_response objectForKey:@"response"] objectForKey:@"photo_hash"], [NSURL URLWithString:[[_response objectForKey:@"response"] objectForKey:@"photo_src"]]);
        }
    }
}

@end
