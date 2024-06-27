//
//  VKSetOnlineRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKSetOnlineRequestResultBlock)();

@interface VKSetOnlineRequest : VKRequest {
    VKSetOnlineRequestResultBlock _resultBlock;
}

- (void)startWithResultBlock:(VKSetOnlineRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
