//
//  VKAPIMessages.h
//  VKMessages
//
//  Created by Sergey Lenkov on 14.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKMessage.h"

typedef void (^VKMessagesHistoryRequestResultBlock)(NSArray *messages);

@interface VKMessagesHistoryRequest : VKRequest {
    VKMessagesHistoryRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (void)startWithResultBlock:(VKMessagesHistoryRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
