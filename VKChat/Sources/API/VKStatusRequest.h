//
//  VKStatusRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 11.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKStatus.h"

typedef void (^VKStatusRequestResultBlock)(VKStatus *status);

@interface VKStatusRequest : VKRequest {
    VKStatusRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;

- (void)startWithResultBlock:(VKStatusRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
