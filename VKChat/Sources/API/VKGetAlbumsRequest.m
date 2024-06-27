//
//  VKAlbumsRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetAlbumsRequest.h"

@implementation VKGetAlbumsRequest

@synthesize userID;
@synthesize groupID;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (void)startWithResultBlock:(VKGetAlbumsRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"photos.getAlbums";
    
    if (self.userID > 0) {
        [self addParamWithKey:@"uid" value:[NSString stringWithFormat:@"%ld", self.userID]];
    }
    
    if (self.groupID > 0) {
        [self addParamWithKey:@"gid" value:[NSString stringWithFormat:@"%ld", self.groupID]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        NSMutableArray *albums = [[[NSMutableArray alloc] init] autorelease];
        
        if ([[_response objectForKey:@"response"] isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [[_response objectForKey:@"response"] count]; i++) {
                NSDictionary *dict = [[_response objectForKey:@"response"] objectAtIndex:i];
                VKAlbum *album = [[VKAlbum alloc] initWithDictionary:dict];
                
                [albums addObject:album];
                [album release];
            }
        }
        
        if (_resultBlock) {
            _resultBlock(albums);
        }
    }
}

@end
