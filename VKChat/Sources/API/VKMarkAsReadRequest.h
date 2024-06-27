//
//  VKMarkAsReadRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKMarkAsReadRequestResultBlock)(NSInteger messageID);

@interface VKMarkAsReadRequest : VKRequest {
    VKMarkAsReadRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger messageID;

- (void)startWithResultBlock:(VKMarkAsReadRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
