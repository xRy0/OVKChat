//
//  VKSetStatusRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"

typedef void (^VKSetStatusRequestResultBlock)(NSString *status);

@interface VKSetStatusRequest : VKRequest {
    VKSetStatusRequestResultBlock _resultBlock;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger audioID;
@property (nonatomic, assign) NSInteger audioOwnerID;
@property (nonatomic, assign) NSInteger userID;

- (void)startWithResultBlock:(VKSetStatusRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
