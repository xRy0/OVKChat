//
//  VKGetMessageRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 23.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"
#import "VKMessage.h"

typedef void (^VKGetMessageRequestResultBlock)(NSArray *messages);

@interface VKGetMessageRequest : VKRequest {
    BOOL isOut;
    NSInteger offset;
    NSInteger count;
    NSInteger filters;
    NSInteger previewLength;
    NSInteger timeOffset;
    VKGetMessageRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) BOOL isOut;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger filters;
@property (nonatomic, assign) NSInteger previewLength;
@property (nonatomic, assign) NSInteger timeOffset;

- (void)startWithResultBlock:(VKGetMessageRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
