//
//  VKDeleteMessageRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKDeleteMessageRequestResultBlock)(NSInteger messageID);

@interface VKDeleteMessageRequest : VKRequest {
    NSInteger messageID;
    VKDeleteMessageRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger messageID;

- (void)startWithResultBlock:(VKDeleteMessageRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
