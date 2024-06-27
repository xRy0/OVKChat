//
//  VKGetLongPullServerRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 27.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKGetLongPullServerRequestResultBlock)(NSString *server, NSString *key, NSInteger ts);

@interface VKGetLongPullServerRequest : VKRequest {
    VKGetLongPullServerRequestResultBlock _resultBlock;
}

- (void)startWithResultBlock:(VKGetLongPullServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
