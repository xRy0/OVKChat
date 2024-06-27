//
//  VKSavePhotoRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 24.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSavePhotosRequest.h"

@implementation VKSavePhotosRequest

@synthesize albumID;
@synthesize serverID;
@synthesize photosList;
@synthesize hash;

- (void)dealloc {
    [photosList release];
    [hash release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.albumID = -1;
        self.serverID = -1;
        self.hash = @"";
    }
    
    return self;
}

- (void)startWithResultBlock:(VKSavePhotoRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"photos.save";
    
    if (self.albumID > 0) {
        [self addParamWithKey:@"aid" value:[NSString stringWithFormat:@"%ld", self.albumID]];
    }
    
    if (self.serverID > 0) {
        [self addParamWithKey:@"server" value:[NSString stringWithFormat:@"%ld", self.serverID]];
    }
    
    [self addParamWithKey:@"photos_list" value:[self.photosList stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self addParamWithKey:@"hash" value:self.hash];
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        NSMutableArray *photos = [[[NSMutableArray alloc] init] autorelease];
            
        if ([[_response objectForKey:@"response"] isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [[_response objectForKey:@"response"] count]; i++) {
                NSDictionary *dict = [[_response objectForKey:@"response"] objectAtIndex:i];
                VKPhoto *photo = [[VKPhoto alloc] initWithDictionary:dict];
                    
                [photos addObject:photo];
                [photo release];
            }
        }
            
        if (_resultBlock) {
            _resultBlock(photos);
        }
    }
}

@end
