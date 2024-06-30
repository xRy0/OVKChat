//
//  VKGetFriendsRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetFriendsRequest.h"

@implementation VKGetFriendsRequest

@synthesize userID;
@synthesize offset;
@synthesize count;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.userID = -1;
        self.offset = -1;
        self.count = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKGetFriendsRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"friends.get";
    
    //[self addParamWithKey:@"user_id" value:[NSString stringWithFormat:@"%ld", self.userID]];
    [self addParamWithKey:@"fields" value:@"id,first_name,last_name,nickname,screen_name,sex,bdate,city,country,timezone,photo,photo_medium,photo_big,has_mobile,rate,contacts,education,online,counters,last_seen,photo_400_orig,bdate"];
    
    if (self.offset >= 0) {
        [self addParamWithKey:@"offset" value:[NSString stringWithFormat:@"%ld", self.offset]];
    }
    
    if (self.count >= 0) {
        [self addParamWithKey:@"count" value:[NSString stringWithFormat:@"%ld", self.count]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        NSMutableArray *friends = [[[NSMutableArray alloc] init] autorelease];
        
        if ([[[_response objectForKey:@"response"] objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [[[_response objectForKey:@"response"] objectForKey:@"items"] count]; i++) {
                NSDictionary *dict = [[[_response objectForKey:@"response"] objectForKey:@"items"] objectAtIndex:i];
                VKProfile *profile = [[VKProfile alloc] initWithDictionary:dict loadPhoto:NO];
                
                [friends addObject:profile];
                [profile release];
            }
        }
        
        if (_resultBlock) {
            _resultBlock(friends);
        }
    }
}

@end
