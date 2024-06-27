//
//  VKSendMessageRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"

typedef void (^VKSendMessageRequestResultBlock)(NSInteger identifier);

@interface VKSendMessageRequest : VKRequest {
    VKSendMessageRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger chatID;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger captchaID;
@property (nonatomic, copy) NSString *captchaKey;

- (void)startWithResultBlock:(VKSendMessageRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
