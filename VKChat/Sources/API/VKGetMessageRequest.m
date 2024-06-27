//
//  VKGetMessageRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 23.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKGetMessageRequest.h"

@implementation VKGetMessageRequest

@synthesize isOut;
@synthesize offset;
@synthesize count;
@synthesize filters;
@synthesize previewLength;
@synthesize timeOffset;

- (void)dealloc {
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.isOut = NO;
        self.offset = -1;
        self.count = -1;
        self.previewLength = 0;
        self.timeOffset = 0;
        self.filters = 1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKGetMessageRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"messages.get";
    
    if (isOut) {
        [self addParamWithKey:@"out" value:@"1"];
    }
    
    if (offset >= 0) {
        [self addParamWithKey:@"offset" value:[NSString stringWithFormat:@"%ld", offset]];
    }
    
    if (count > 0) {
        [self addParamWithKey:@"count" value:[NSString stringWithFormat:@"%ld", count]];
    }
    
    [self addParamWithKey:@"filters" value:[NSString stringWithFormat:@"%ld", filters]];
    [self addParamWithKey:@"preview_length" value:[NSString stringWithFormat:@"%ld", previewLength]];
    [self addParamWithKey:@"time_offset" value:[NSString stringWithFormat:@"%ld", timeOffset]];
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        NSMutableArray *messages = [[[NSMutableArray alloc] init] autorelease];
        
        if ([[[_response objectForKey:@"response"] objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
            for (int i = 1; i < [[[_response objectForKey:@"response"] objectForKey:@"items"] count]; i++) {
                NSDictionary *dict = [[[_response objectForKey:@"response"] objectForKey:@"items"] objectAtIndex:i];
                VKMessage *message = [[VKMessage alloc] initWithDictionary:dict];
                
                [messages addObject:message];
                [message release];
            }
        }
        
        if (_resultBlock) {
            _resultBlock(messages);
        }
    }
}

@end
