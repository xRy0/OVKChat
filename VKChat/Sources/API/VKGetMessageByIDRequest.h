//
//  VKGetMessageRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKMessage.h"

typedef void (^VKGetMessageByIDRequestResultBlock)(VKMessage *message);

@interface VKGetMessageByIDRequest : VKRequest {
    NSInteger messageID;
    VKGetMessageByIDRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger messageID;

- (void)startWithResultBlock:(VKGetMessageByIDRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
